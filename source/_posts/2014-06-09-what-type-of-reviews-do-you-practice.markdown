---
layout: post
title: "What Type of Reviews Do You Practice?"
date: 2014-06-09 00:00
comments: true
categories: practices, database
published: false
---

A professor of mine asked about the kind of "reviews" that I've practiced in the industry. In the [verification & validation][1] classes, they cover a wide array of practices. Some are more popular than others.

 * Ad Hoc Review
 * Peer Desk-Check
 * Passaround
 * Pair Programming
 * Walkthroughs
 * Team Reviews
 * Formal Inspections

I've had several jobs since college, worked on a few different teams within those jobs, and have a some different perspectives.

## Pair Programming

One of the teams I worked on was part of a "rescue" project. We were rewriting the control software for a medical device. It was late and over-budget and we had almost nothing usable except the theory of operations. We practiced [pair programming][2] on nearly all production and test code. This practice allowed us all to come up to speed together and avoid a point of failure (improving our "functional redundancy" or "resiliency"). We were able to design and code at the same time (navigator/driver theory). We were able to work quickly and iterate several times in one pairing session on an idea.

## Team Review

At X, the only practice I see formally enforced is code reviews (there's not much informal review going on, maybe desk check or one of those looser practices). We use a repository browser/review tool called Crucible that supports discussion over diffs, workflow (open, in-progress, completed), and integration with our issue tracker. My opinion is that our code is of low quality. I don't know that these reviews are helping or hurting... it's probably more a problem of culture than process/technology. Review-after-coding does not help to improve design, but may point out consistency/formatting issues and glaring syntactical defects.

## Pull Request

In my open-source experience and where I get to use it at work (on small/side projects), we use pull requests from forks or branches. This method is really just discussion over diffs on steroids. You can view the diffs and commit messages, carry on inline commentary, and continue to add commits to the request to address comments. Besides GitHub having one of the best interfaces (which can make or break energetic, deep reviews), it acts as a gate. The code is fully committed (safe) and reviewable (good), but it's not in the trunk yet. The owners of the repository/branch get control of that decision.

 [1]: https://en.wikipedia.org/wiki/Verification_and_validation_(software)
 [2]: http://www.jamesshore.com/Agile-Book/pair_programming.html
 [3]: https://www.atlassian.com/software/crucible/overview/feature-overview
 [4]: https://github.com/blog/712-pull-requests-2-0
 [5]: https://help.github.com/articles/using-pull-requests
 
