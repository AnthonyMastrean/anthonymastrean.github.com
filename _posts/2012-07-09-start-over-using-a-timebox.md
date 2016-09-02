---
layout: post
title: "Start Over Using a Timebox"
date: 2011-05-19 00:00
---

I was refactoring an internal application used in automated testing. It's one of those tools that was written quickly, but inevitably outgrew it's original purpose. I extracted a lot of [hidden concepts][con] and made many of the [features][fea] explicit. Then I was in the code-behind facing down three timers, a handful of conditional loops, and cross-thread invocations.

I was unable to make progress. I wanted to start from scratch. But that's a great way to lose context, to throw away the hard work that's hidden in the original, and an opportunity to miss a feature. So I asked my coworker, [Chris][cg], what he thought. He said to timebox a session in "starting over." Take two hours to rewrite the parts I was having trouble with and see what happens.

So, I created a private branch, threw away all the code-behind, and started experimenting. Two hours later, I was satisfied with the commands and made some improvements over my original changes. But, I found an implicit bit of WPF dispatcher magic that was actually very critical to the functionality of this application. And I failed to fix it, twice.

The timebox was a life-saver. I hadn't committed to rewriting this part of the application. I didn't even realize it existed! Instead of getting in over my head and breaking the application or scrambling to fix or rollback the changes, I gained a working knowledge of the feature.

Now, I can schedule some time with the authors of the application or get some help from another developer that's an expert in this area and get some real work done.

 [con]: http://ayende.com/blog/3895/application-structure-concepts-features
 [fea]: http://lostechies.com/jimmybogard/2010/09/30/concepts-and-features-an-example/
 [cg]: https://twitter.com/seejee
