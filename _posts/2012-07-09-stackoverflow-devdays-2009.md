---
layout: post
title: "StackOverflow DevDays 2009"
date: 2009-09-28 00:00
---

_I attended the StackOverflow DevDays conference in Washington, DC in October 2009. Also see the official [notes round-up][1]._

----

## Joel Spolsky on Software Design and Development (Keynote)

The scale of "Simplicity vs Power" was introduced, with reference to the Pareto Principle. He contrasted "less is more" vs delivering features. But it was too naive, those things aren't exclusive.

So the scale of "Good Features" and "Bad Features" was proposed. In particular, what do people care about vs controlling the user. Particularly, you shouldn't ask your user to make a decision they are unqualified to make! That is a failure to design.

The end point was that features (and code) should be elegant. **Elegance is the modesty to not draw attention to the challenges that have been surmounted.** Read more about opinionated software.

## Dan Pilone on iPhone Development Strategy

The main idea is that you aren't going to get rich quick, but there is money to be earned. You have a small space (physically and in resources) and a short time to make an impression (average user uses an application for 6 minutes). Apple is strict about violations of the HIG or IP. The approval process takes 2 weeks whether an app is accepted or rejected.

## Scott Allen on ASP.NET MVC

Microsoft's answer to Ruby on Rails, Django, and the webforms problem in general. The technical bits are solid and all available online. The real takeaway here was Convention Over Configuration.

## Joel Spolsky on FogBugz

His focus was on its key feature, Evidence Based Scheduling (taking into account not just velocity, but accuracy in estimation). One of the major takeaways was this advice on estimation.

> If your task is estimated in days, you have no idea what you're building. Break it down until you've got an estimate of hours.

## Jonathan Blocksom on Google App Engine

The Google Moderator app was built on the GAE (used in the 2008 elections!). It's a "cloud" application hosting service. You've got access to Google's BigTable (soon to be MegaStore) for data but no filesystem. The whole service is throttled and managed unless you pay for higher caps (rule of thumb, you have <1000 of everything without paying).

## Rich Worth on jQuery

> It changes the way you write JavaScript.

Like CSS separated content and presentation, jQuery separates content and behavior. You can include the jQuery library from Google's or Microsoft's hosted address (it's likely that clients already have it cached).

## Bruce Eckel on Language Evolution and Philosophy

He said developers are 10x more productive in a dynamic language. It has to do with holding a problem in your head (dynamic languages are often more terse and have less structure, you can think about the code and the problem 1-to-1). And near the end, he talked about solving threading problems with dynamic languages (paying close attention to the difference between [concurrency and parallelism][conc]).

## Dave from OPower on Improving Sprints

The idea is that, for continuous improvement, you select one bad metric and target it.

1. Start by tracking the metric (defects, code coverage) in the context of story points (the size of the iteration is a good measure with meaning).
2. Make a hypothesis about a process/tool that will fix the problem or improve the measurement ("pair programming will reduce defects" or "TDD will increase test coverage").
3. Experiment! (perform the next sprint, with the process/tool you hypothesized).
4. Compare the metrics.

 [1]: http://meta.stackoverflow.com/questions/27367/devdays-2009-reviews-washington-dc
