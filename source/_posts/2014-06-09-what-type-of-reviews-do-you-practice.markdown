---
layout: post
title: "What Type of Reviews Do You Practice?"
date: 2014-06-09 00:00
comments: true
categories: practices, database
published: true
---

A professor of mine asked about the kinds of "reviews" that I have practiced in the industry. They cover a wide range of practices in the [verification & validation][1] classes. Times, practices, and industry has changed and so some of these are more popular and others are practically unheard of anymore.

 * Ad Hoc Review
 * Peer Desk-Check
 * Passaround
 * Pair Programming
 * Walkthroughs
 * Team Reviews
 * Formal Inspections

I worked on contract teams, at a startup, and in the enterprise on enterprise software, mobile applications, and medical devices. So, I have some different perspectives, but it boils down to the following three practices.

## Pair Programming

One of the teams I worked on was part of a rescue project. We rewrote the control software for a medical device. It was late,  over-budget, and we had nothing salvagable except the theory of operations. We practiced [pair programming][2] on nearly all production _and_ test code. This allowed us to come up to speed together and avoid a single point of failure or bottleneck ("We can't complete this module because Chris is on vacation!"). We improved our "functional redundancy" or "resiliency" in this way. We were able to design and code at the same time (navigator/driver). We worked quickly and could iterate several times on a design or module in one pairing session.

## Team Review

At most of my enteprise jobs, the only practice formally enforced was code review. There never was much informal review. Folks would occassionally ask for a "desk check" or the like. We often used separate repository browser tools (a popular one is [Crucible][3]) that support discussion over diffs, workflow (open, in-progress, completed), and integration with the issue tracker. In most of these places, the code was mediocre in quality and design. I don't know that code reviews were the cause. An after-coding review may point out consistency, formatting, or glaring syntactical issues, but it cannot usually improve design.

## Pull Request

In my open-source experience, we used [pull][5] [requests][4] from forks or branches. This method looks like discussion over diffs on steroids. You can view diffs and commit messages, carry on inline commentary, and continue to add commits to the request to address comments. GitHub simply has one of the best interfaces, which can make or break an energetic, deep review. A pull request also acts as a gate. The code is fully committed (safe) and reviewable (good), but it's not in the "master" branch yet. The owners of the repository/branch get control of that decision.

 [1]: https://en.wikipedia.org/wiki/Verification_and_validation_(software)
 [2]: http://www.jamesshore.com/Agile-Book/pair_programming.html
 [3]: https://www.atlassian.com/software/crucible/overview/feature-overview
 [4]: https://github.com/blog/712-pull-requests-2-0
 [5]: https://help.github.com/articles/using-pull-requests
 
