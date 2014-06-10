---
layout: post
title: "High Performance Appending with log4net"
date: 2011-05-26 00:00
comments: true
categories: log4net logging performance measurement
---

It is important to understand the implementation of a log call before making changes for performance. If you already [configured][conf] log4net and have an instance of `ILog`, any log call is simple.

1. Retrieve all `Appenders` for the `Level`.
1. Call `Append(LoggingEvent)` on each `Appender`.

The executing code in the `RootLogger` is

```
foreach (IAppender appender in this.m_appenderArray) 
{ 
    try 
    { 
        appender.DoAppend(loggingEvent); 
    } 
    catch (Exception exception) 
    { 
        LogLog.Error("AppenderAttachedImpl: Failed to append to appender [" + appender.Name + "]", exception); 
    } 
}
```

Without measuring, I can only estimate that the majority of any log call is spent inside the `Appender`. Continuing with my theme of not modifying log4net, I have a few suggestions on how to get faster logging.

## Trace Appender

For situations that demand 10s or 100s of messages a second, the [`TraceAppender`][trace] cannot be beat. The Trace system in .NET is used for low level logging and is especially useful when you don't want the baggage of a beefier appender. Frameworks like NHibernate output their most detailed logs using the Trace system. The `TraceAppender`'s `Append` method is

```
Trace.Write(base.RenderLoggingEvent(loggingEvent), loggingEvent.LoggerName); 
if (this.m_immediateFlush) 
{ 
    Trace.Flush(); 
}
```

## Buffering Forwarding Appender

The [`BufferingForwardingAppender`][buff] buffers log messages until a message count threshold is met, then sends them to the actual appender. The buffered write occurs synchronously (it executes the same appender loop as the `RootLogger`). I suggest tweaking the buffer threshold to ensure your high performance scenario is over before or near when the buffer is full. To further control when the buffer is sent to the forwarded appender, you can [configure][lossy] a [`Lossy`][buff-mode] mode. The buffer will only be sent when a message with a certain `Level` is met. This is useful if you only care about the messages when something exceptional happens (for example, if a performance threshold is not met, you can log a `Warning` or `Error` and cause the buffer to send).

## Logging on another thread

The last resort, without modifying log4net, is to log on another thread. I see two ways about this: set up an internal async logging infrastructure or writing an asynchronous appender. An internal threaded logging infrastructure can be as simple as

```
ThreadPool.QueueUserWorkItem(x => Log.Debug("The last service call took {0} ms.", timer.ElapsedMilliseconds));
```

But now you've got questions about message ordering, `ThreadPool` configuration, and so on. I think this infrastructure will end up much more complex than it looks. My suggestion, if you have to continue down this path, is to write an asynchronous appender. Call it `AsyncForwardingAppender`, inherit from `BufferingForwardingAppender`, and override the `SendBuffer` method. You'll need to use Reflection to call the `AppendLoopOnAppenders` method in a background thread. Or you can thread each call to `Append` on the `Appenders` collection.

I haven't used any of these asynchronous methods in production, and I would avoid them until all other options are exhausted. *UPDATE: Definitely don't write an asynchronous appender!*
I played with the [`AsyncForwardingAppender`][repo] idea and I hit some major obstacles very quickly. 

1. To be based on the `ForwardingAppender`, async needs to [make sense][sense] for every appender. The `ConsoleAppender`, `MemoryAppender`, and others just don't make sense with async. 
1. Threads are heavy-weight for running just appenders. [IO completion ports][io-ports] should be used, but they're hard! And they may not make sense for every appender (`MemoryAppender`, `BufferedForwardingAppender`).
1. An easier solution would be sending logging events to a [shared resource][log-svc] that calls log4net on a background thread.

## Let's Measure
While I was writing this, my coworkers were arguing about the performance of writing large events to disk with the [`FileAppender`][file]. In each scenario, I logged 1000 x 1 MB messages.

1. Sequentially from one `ILogger` (a desktop application scenario)
1. Concurrently with both `ThreadPool` and `Thread` from one `ILogger` (a server scenario)
1. Concurrently from a new `ILogger` instance per message (just for fun, to force a lot of instance creation and to prove how good log4net is)

In all scenarios, the time to complete the log call was <1 ms on average. Yep, no performance problems. Measure before making assumptions! I learned, from reflecting log4net, that the `Log` call is synchronous only until the final append call. The appender may be designed in a buffered or threaded manner. In the case of the `FileAppender`, the final appending is left to highly optimized native IO (whatever's going on in `TextWriter`, to be exact).

 [conf]: http://logging.apache.org/log4net/release/config-examples.html
 [trace]: http://logging.apache.org/log4net/release/sdk/log4net.Appender.TraceAppender.html
 [buff]: http://logging.apache.org/log4net/release/sdk/log4net.Appender.BufferingForwardingAppender.html
 [buff-mode]: http://logging.apache.org/log4net/release/sdk/log4net.Appender.BufferingAppenderSkeleton.Lossy.html
 [buff-skel]: http://logging.apache.org/log4net/release/sdk/log4net.Appender.BufferingAppenderSkeleton.html
 [lossy]: http://www.beefycode.com/post/Log4Net-Tutorial-pt-8-Lossy-Logging.aspx
 [repo]: https://github.com/AnthonyMastrean/log4net.intro/blob/master/Intro.Contrib/Appender/AsyncForwardingAppender.cs
 [sense]: http://www.l4ndash.com/Log4NetMailArchive/tabid/70/forumid/1/postid/15068/view/topic/Default.aspx
 [io-ports]: http://marcgravell.blogspot.com/2009/02/async-without-pain.html
 [log-svc]: http://www.mail-archive.com/log4net-user@logging.apache.org/msg02168.html
 [file]: http://logging.apache.org/log4net/release/sdk/log4net.Appender.FileAppender.html