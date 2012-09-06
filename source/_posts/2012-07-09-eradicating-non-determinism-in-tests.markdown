---
layout: post
title: "Eradicating Non-Determinism in Tests"
date: 2011-04-25 19:06
comments: true
categories: tests isolation async
---

[Martin Fowler's][mf] [Eradicating Non-Determinism in Tests][mf-blog] is full of great tests patterns and practices for beginners. I realized that I have problems with asynchronous code in tests. I have a sensor that determines if another piece of hardware is inserted or not. I need to poll the sensor's status until it changes to do something fancy on-screen.

```
public class SlideHolderOrchestrator
{
    public void StartPollingSlideHolderState()
    {
        _poller.Start(() => 
        { 
            // do interesting work with the hardware manager
        });
    }
}
```

In the test, I have to stub the hardware to return different states. I can't actually start a background polling cycle, so I have to run a synchronous helper method `SimulateAPollingCycle`.

```
public class When_the_slide_holder_is_unloaded_and_later_is_loaded
{
    Establish context = () =>
    {
        _poller.Stub(x => x.Start(null, null))
            .IgnoreArguments()
            .Return(null)
            .WhenCalled(m => { _action = (Action) m.Arguments[0]; });

        _slideHolder.Stub(x => x.GetIsSlideHolderInserted())
            .Return(false)
            .Repeat.Once();
        
        _slideHolder.Stub(x => x.GetIsSlideHolderInserted())
            .Return(true)
            .Repeat.Once();
    };

    Because of = () =>
    {
        Subject.StartPollingSlideHolderState();
        SimulateAPollingCycle();
        SimulateAPollingCycle();
    };

    It should_raise_the_slide_holder_state_changed_event = () => ... ;

    protected static void SimulateAPollingCycle()
    {
        _action();
    }
}
```

It works, but it sure is ugly! What I should do is [extract the contents][xunit-hop] of the method under test, `StartPollingSlideHolderState`. A test should pump that method for each stub on the hardware. Then, the orchestrator can just make sure that it's delegating some action to some poller. The orchestrating class looks a lot simpler now. It brings the polling action and the poller together in sweet unison.

```
public void StartPollingSlideHolderState()
{
    _poller.Start(_slideHolderStatePollingAction.Poll);
}
```

I can test it in isolation

```
public class When_starting_to_poll_slide_holder_state
{
    Because of = () => Subject.StartPollingSlideHolderState();

    It should_start_the_poller = () => _poller.AssertWasCalled(x => x.Start(_slideHolderStatePollingAction.Poll));
}
```

And the specs for the polling action have moved and become a lot simpler. Each hardware stub is satisfied by a call directly to the `Poll` method.

```
public class When_the_slide_holder_is_unloaded_and_later_is_loaded
{
    Establish context = () =>
    {
        _slideHolder.Stub(x => x.GetIsSlideHolderInserted())
            .Return(false)
            .Repeat.Once();
        
        _slideHolder.Stub(x => x.GetIsSlideHolderInserted())
            .Return(true)
            .Repeat.Once();
    };

    Because of = () =>
    {
        Subject.Poll();
        Subject.Poll();
    };

    It should_raise_the_slide_holder_state_changed_event = () => ... ;
}
```

I feel a lot better about changing the infrastructure, behavior, and orchestration with the separate specs and responsibilities. Our poller implementation wraps a task factory `Task` and the `Stop` method has access to the cancellation token. Check out the assertion on this test

```
public class When_a_poller_is_stopped
{
    It should_not_keep_running = () => ((double)CallCount).ShouldBeCloseTo(_expectedCallCount, 1);
}
```

That's right, I have to cast it to a double to get access to `ShouldBeCloseTo` because the thing doesn't always stop right away!

 [mf]: https://twitter.com/martinfowler
 [mf-blog]: http://martinfowler.com/articles/nonDeterminism.html
 [xunit-hop]: http://xunitpatterns.com/Humble%20Object.html