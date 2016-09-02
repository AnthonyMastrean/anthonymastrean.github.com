---
layout: post
title: "Build Automation"
date: 2015-05-19 00:00
---

I participated in an online panel on [Build Automation: Quality and Velocity at Scale](http://electric-cloud.com/blog/2015/05/continuous-discussions-c9d9-episode-16-recap-build-automation/) as part of Continuous Discussions (#c9d9), a series of community panels about Agile, Continuous Delivery and Devops. Automating the build pipeline has many challenges, including 3rd party dependencies, consistency and standardization, and testing.

<iframe width="560" height="315" src="https://www.youtube.com/embed/mNM8Vol2H9o" frameborder="0" allowfullscreen></iframe>

Continuous Discussions is a community initiative by [Electric Cloud](http://electric-cloud.com/powering-continuous-delivery/), which powers Continuous Delivery at businesses like SpaceX, Cisco, GE and E*TRADE by automating their build, test and deployment processes.

Below are a few insights from my contribution to the panel:

## What do build bottlenecks mean for your pipeline?

> I work on a very large legacy application. We have a thick client run by retail pharmacies over dial up lines. There is an enormous centralized database in the backend. Recently I am hearing a lot about build automation. But the build is just one small piece of building value to the customers. I am thinking about my process throughout the pipeline and all the teams I am supporting; starting from when the pharmacy owner has a problem and we develop a solution, test it, and develop documentation and training materials. They need to get all their pharmacists together to learn the new solution. And then we finally can deploy a new version. This pipeline spans 18 months. And that’s not good. I wish it was a lot faster. But I am thinking, what good does it do if I speed up this one small part of the build?

<!-- -->

> If we can commit faster then there’s more in a branch that QA needs to test and that needs documentation and training. So the customers are less likely to take builds, because they have to get their work done. I am trying to think about making our build better. But honestly, I wish these guys would slow down. I wish that they were given some slack because development isn’t even our bottleneck, if you look at the full process. So that’s the conflict I’ve got professionally. There’s the duality that I really do want to have great tools, builds, pipelines, and good feedback. But it doesn’t matter if we can’t get stuff out for 18 months.

<!-- -->

> I’ll try not to be too much of a nay-sayer about build automation because I really am excited by it. But I am worried that we don’t focus enough on full system effectiveness.

<!-- -->

> I wonder if it’s a chicken and egg problem – I can’t make the people on the dev team more efficient if the people upstream of us can’t keep up. I do not control the entire organization, the trainers and others. But if I can make this team more efficient, maybe we can be a better partner in the overall solution. So I can still get excited about build automation for that reason.

## What do you think about consistency and standardization in the process?

> My biggest technical problem is with build tools that let you write a build step inside their GUI and all they’re doing is wrapping a shell exec - you write this complicated multi-step, post-condition, pre-condition build and only your build server knows about it.

<!-- -->

> Then if your build server goes down or if an AWS region goes down, nobody can run a build because it is not actually in source control. So as nice as those features are, they may be easy to set up but aren’t going to be maintainable. Let’s write all of our build steps in some sort of a DSL, let’s check it in, the build server should be some fancy central wrapper. When the teams are excited to do it, we build up a vagrant development machine.

<!-- -->

> I don’t care what my build server does or how the agents are configured - as long as they have a virtual box and Vagrant, they boot up a machine to do whatever. I look at those and offer advice. We share best practices. But honestly, whatever they do inside their Vagrant box is their own. They can fight with Ops later about how it deploys. At least I can take that box and build it on any machine anywhere.

## Can integrated tests help speed up the pipeline?

> I think integrated testing is a scam. Unit tests should be enormously fast. You should run thousands of them per second. So if you’re writing good unit tests that are running quickly, your product should not be large enough that your unit tests are going to take too long.

<!-- -->

> With the integrated tests cycle, when you do the mathematics and multiply out the combinations for even a simple screen, if you think you’re writing enough integrated tests to cover all the paths of your system, you probably aren’t. And the cost in time and effort to write and run enough integrated tests is just so mindboggling – I mean we’re talking about tens and hundreds of thousands of paths. So I think that integrated testers, if you write a couple of contract tests or do a single smoke test, for example: “Is the app up? Can I log in?” then I don’t see how that will ever slow you down. But then I haven’t gotten that far in my own application so it’s all theoretical.
