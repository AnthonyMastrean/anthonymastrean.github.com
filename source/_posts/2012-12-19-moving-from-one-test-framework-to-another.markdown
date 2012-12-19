---
layout: post
title: "Changing Test Frameworks"
date: 2012-12-19 17:46
comments: true
categories: 
---

I have two different stories for you

 1. moving from one unit test framework to another (from mstest to mspec)
 2. dabbling in context-specification style (from storyteller to specflow to mspec)

# Moving Unit Test Frameworks

MSTest is the default test framework and test runner used by, I'm guessing, most .NET developers. It's baked in to (most) versions of Visual Studio. And is the easiest tool to use (it's literally the "closest at hand").

So, why would you want to move? What am I selling you? Or have you already had feelings (are there "tool smells"?) that MSTest isn't quite right for you.

Well, it's a slow framework, based on its fundamental implementation. And it encourages too much bad behavior. You could say that it's not opinionated enough. Or that the documentation is very naive.

I got a lot of problems with you frameworks! And now, you're gonna hear about it.

## Test Class Instance Per Test
You'd think that this would support isolation of test class members. But it's not obvious when test methods are instance methods. And it's obvious that it's not working when I continue to see unnecessary test initializers and cleanup.

```
[TestClass]
public class MyTests
{
    private Thing _subject;
    
    [TestInitialize]
    public void Initialize()
    {
        _subject = new Thing();
    }
    
    [TestCleanup]
    public void Cleanup()
    {
        _subject = null;
    }
    
    [TestMethod]
    public void Test_1()
    {
        // whatever
    }
}
```

Instance per test method, use your constructor and field initializers! If you read about and reason about your test framework you would have this (yes, I'm showing you how to use the framework I'm not recommending)...

```
[TestClass]
public class MyTests
{
    private readonly Thing _subject = new Thing();
    
    [TestMethod]
    public void Test_1()
    {
        // whatever
    }
}
```

## Isolation Per Test, Async or Sync?
Every test assembly is started in it's own `AppDomain` and every test run in its own thread. They are supposed to run in parallel, but I always notice some kind of lag to where it always *looks* synchronous. It's crushingly slow to startup and execute an MSTest session.

There wasn't parallel test running support until recently (across CPUs). And even now, you have to [hand edit][1] the test settings XML file. Some 3rd party test runners pick up this slack automatically.

I'm kind of on the fence about this. MSTest claims to do some things in the name of isolation (good) and in parallel (good), but the results of the test run (slow, slow, s l o w) definitely contrast these ideas.

I can write the same tests in MSpec and get a much faster run. And it does synchronous execution.

## Major Missing Features 
Let's just jot down a few items

* catch exception statements: `_ex = Catch.Exception(() => _subject.DoSomething());`
* categories or tags, for custom test runs: `[Tag("integration", "slow", "feature-foo")]`
* row tests (don't get me started on [data-driven tests][2]): `[Row(1, false)]`
* collection assertions: `_list.ShouldContainOnly(_expected)`

## Obscure and Locked In
* special assembly/project type
* Can't have multi framework test project
* VSMDI file, test lists
* requires Visual Studio, no standalone install of MSTest

## Bad grammar, idioms, and patterns (research)
* look at the fundamental examples, this is why we have people testing getters and ctors

But, hope is in sight! You can allow seamlessly switch to nunit (which will, at least, get you a "native" multi test runner). 

Show nuget package install and tools package. Maybe resharper integration?

Code block
Show nunit to mstest aliases
Code block

Why to move from nunit to mspec? Same grammar reasons. Introduce the xunit test patterns. Try test case class per fixture in traditional nunit.  Then compare in mspec!

You don't have to move all at once. Actually, I don't recommend it at all. Both tests can live in one assembly!

Write all new tests in mspec style. Even regressions and bug fixes.

Code block
Mspec test style
Code block

Tags, reports, best grammar supports the best test patterns. 

Ok, what's the downside though?
* no built in multi test run, requires resharper or command line mess (show rake multi run w/ console output problems and reports req)

 [1]: http://blogs.msdn.com/b/vstsqualitytools/archive/2009/12/01/executing-unit-tests-in-parallel-on-a-multi-cpu-core-machine.aspx
 [2]: http://msdn.microsoft.com/en-us/library/ms182527(v=vs.80).aspx