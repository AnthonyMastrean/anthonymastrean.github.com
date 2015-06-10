---
layout: post
title: "A Project Management Revelation"
date: 2015-06-10 00:00
comments: false
categories: project-management culture
published: true
---

A short description of this post might be...

> "The revelation of the developer Paul: the things which were revealed to him when he attended the status meetings and heard unspeakable words."

The developer in this story had been attending status meetings. These were good meetings, they were early attempts at transparency and cross-functional communication. They were snappy and there was always time for questions.

For weeks, the project management team had been presenting the general status of the many releases that were in various stages of the software development lifecycle. Yes, there were released versions in support, receiving patches and hotfixes, versions in active development, and versions being planned and experimented on for future release.

The statuses were like: 

 * Bad, we're going to miss a deadline or slip a feature. (`-`)
 * In trouble, we're trending downards. (`~`)
 * Good! Everything's on track. (`+`)

And the presentation of these releases and status often looked like this, let's say that 1.0 is the current released version, 2.0 and 2.1 are in various stages of development or testing, and 3.0 is in planning.

``` linenos:false
| 1.0 | 2.0 | 2.1 | 3.0 |
|-----|-----|-----|-----|
| `-` | `~` | `~` | `+` |
```

Of course, we're "trying hard" to meet that deadline or to get that feature in. But, are we really changing? Are we reorganizing the teams around the most important goals? Are we communicating hard messages to customers about that future service pack so that we can meet the 1.0 goals?

It's not really clear sometimes. Let's skip ahead and look at the reported progress as old releases rolled out and new ones popped in.

``` linenos:false
| 2.0 | 2.1 | 3.0 | 4.0 |
|-----|-----|-----|-----|
| `-` | `~` | `~` | `+` |
```

Wait, a minute... 2.0 isn't improving and 2.1 is still in trouble. But, look, 4.0 is doing great! The key understanding was a quote(ish) from the project manager...

> Of course, 4.0 is looking good because we haven't started working on it yet! *(chuckles)*

That's actually a kind of nefarious statement. If you understand that "working on it" means "starting the development phase". The problems start when the damn developers get their hands on the perfect requirements.

You'll see, over time, that the statuses are fixed. They'll always appear in that state in that order. The releases simply roll over them, like a wave.

``` linenos:false
| 1.0 | 2.0 | 2.1 | 3.0 | 4.0 | 4.1 |
|-----|-----|-----|-----|-----|-----|
| `-` | `~` | `~` | `+` |     |     |
|     | `-` | `~` | `~` | `+` |     |
|     |     | `-` | `~` | `~` | `+` |
```

I believe that the feedback loops between the teams are broken. The organization is not collaborating across the teams towards a shared goal. There is no real change, so the statuses will never change.
