---
layout: post
title: "Performance is not a Level"
date: 2011-05-25 00:00
comments: true
categories: log4net logging performance single-responsibility
---

Have you ever wanted to log performance metrics? If you're using [log4net][l], have you implemented a custom `ILog` and added a new `Level`? That requires adding *five* new members to `ILogger`, creating a new `LogManager`, and overriding/assigning a new `Level` in the application configuration.

```
private static readonly IExtendedLog Log = ExtendedLogManager.GetLogger(typeof(StreamingClient)); 
...
var timer = Stopwatch.StartNew(); 
service.Invoke(); 
timer.Stop(); 
Log.Perf("The last service call took {0} ms.", timer.ElapsedMilliseconds);
```

So, now you have a custom version of log4net and you're headed down the wrong path! Why? Do you need to capture Audit information too? Are you going to create *another* `ILog` implementation with another `Level` and modify the `LogManager` again? Think about it this way, are some Performance measurements for debugging?

> Created leaf node in 13 ms.

Are some Performance measurements informational, good for a dashboard?

> Remote service call 'Foo' took 20 seconds.

Are some Performance measurements indications of fatal system problems that should wake up an IT guy?

> The last service call was over threshold at 60 seconds.

When Performance is a level in every logger, we cannot capture the intent of *any* performance message. When Performance is a logger, we have the full capabilities of log4net at our disposal.

```
private static readonly ILog Log = LogManager.GetLogger("Performance"); 
... 
var timer = Stopwatch.StartNew(); 
service.Invoke(); 
timer.Stop(); 
Log.Debug("The last service call took {0} ms.", timer.ElapsedMilliseconds);
```

But, let's keep driving this idea... Performance is a [non-functional characteristic][feat] of the application and should be implemented like any other feature. Measuring and logging performance should be performed through classes, with their *own* loggers, so that they can participate in the full functionality of log4net (filtering by level, turning hierarchical loggers on/off, etc). I'm not going to implement a complete solution here, but I prototyped two patterns quickly. The first is a delegate based pattern that measures the execution time of any action.

```
public static class Timing 
{
    private static readonly ILog Log = LogManager.GetLogger(typeof(Timing)); 

    public static void MeasureDuration(string description, Action action) 
    { 
        var watch = Stopwatch.StartNew(); 
        action(); 
        watch.Stop(); 
        Log.InfoFormat("{0} took {1} ms to complete.", description, watch.ElapsedMilliseconds); 
    } 
} 
```

```
public void SomeOtherMethod() 
{ 
    Timing.MeasureDuration("Invoking some service", () => 
    { 
        // Do some work 
    }); 
} 
```

The other pattern is implicit, measuring the execution time from construction until disposal of the class (this class could be passed to a callback for disposal).

```
public class MeasureDuration : IDisposable 
{ 
    private static readonly ILog Log = LogManager.GetLogger(typeof(MeasureDuration));

    private readonly String description; 
    private readonly Stopwatch watch = Stopwatch.StartNew(); 

    public MeasureDuration(string description) 
    { 
        this.description = description; 
    } 

    public void Dispose() 
    { 
        watch.Stop(); 
        Log.Info("{0} took {1} ms.", description, watch.ElapsedMilliseconds); 
    } 
}
```

```
public void SomeOtherMethod() 
{ 
    using(new MeasureDuration("Invoking some service")) 
    { 
        // Do some work 
    } 
}
```

 [l]: http://logging.apache.org/log4net/
 [feat]: http://www.mockobjects.com/2007/04/test-smell-logging-is-also-feature.html
