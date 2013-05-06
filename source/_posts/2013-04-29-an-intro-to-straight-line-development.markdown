---
layout: post
title: "An Intro to Straight-Line Development"
date: 2013-04-29 08:24
comments: true
categories: mercurial dvcs practices
---

_Github pages is having issues serving images. I've contacted support and they're aware of the problem and working on it. For now, you can view the images [in the raw][3]. Sorry!_
<hr />

I only started using Mercurial (Hg) a few weeks ago, so I'm going out on a limb here. I'm going to describe what straight-line development is, why it's valuable, and how to practice it! This is what the commit graph looks like on most days, especially after waiting a few days to push to the public repository. The best things about DVCSs can also induce headaches.

{% img /images/straight-line-development/01-merge-history.png %}

You're seeing at least three merge commits across five lines of development (I don't know where these things come from!). That graph is pretty hard to follow. But, we're all working directly on the default branch. The contribution workflow should be very straight-forward. These aren't true feature-branch merges. They're remote repo race-to-pull-and-push-merge-commits!

What we should see when we're done pushing is a straight line. There's something more clean, clear, and polite about this kind of history. And it's actually a truer representation of the way things were done. (Ignore the broken builds!)

{% img /images/straight-line-development/02-straight-history.png %}

> It's a good idea to provide these contribution guidelines in your repository, try a `CONTRIBUTING.txt` file!

So, how do we go about doing this? It starts with some Mercurial extensions, which seems to be Mercurial's way of trying out new features without committing to them. When they get good, they get packaged up with the official Mercurial installation. We're going to enable the [`rebase` extension][1].

* Enabled per-user at `~\.hgrc`
* Enabled per-repository at `repo/path/.hg/hgrc`

Just add the extensions category and an empty assignment

```
[extensions]
rebase = 
```

Now you have access to some new commands (check out `hg help rebase`). But, the one I'm going to show is the integration with your tried-and-true, `hg pull`. You can now do

```
hg pull --rebase
```

But, what does rebasing do? In a nutshell, it stashes any un-pushed commits in your local repository, pulls commits from the remote repository that you don't have yet, then replays (or rebases) your stashed local commits, one at a time, on top of the public commits. What this does is create a history where the public commits occurred before any of your local changes.

You essentially lost a race to push changes to the public repository. And, instead of assaulting us with many merge commits, you're responsible for merging your local changes onto the public history.

Then you can simply push this rebased history back up to the public repository in a straight line.

> There's something funny about rebase merge conflicts that I haven't figured out and I think I got it wrong once. If you rebase and need to merge, please read the Hg prompts very carefully and make sure you fully resolve the conflicts and complete the rebase entirely. I'll come back and write more when I encounter this scenario again.
>
> `warning: conflicts during merge.`
> `abort: unresolved conflicts (see hg resolve, then hg rebase --continue)`

There are some tools to help you manage this workflow that you may already be familiar with. You can spy on the remote commits that you haven't pulled yet. These will become part of the history before your commits.

```
hg incoming
```

And you can spy on your local commits that haven't been pushed yet. These are the commits that will be replayed on the new history.

```
hg outgoing
```

## Let's Play with History

Another workflow that plays well with straight-line development is the ability to squash multiple local commits into one, to amend commit messages, or otherwise _lightly_ play with your local commit history _before_ pushing. Check out the capabilities of the [`histedit` extension][2]. It is also included in Mercurial and can be enabled the same as the others.

```
[extensions]
histedit = 
```

I like to rewrite commit messages to use good grammar and punctuation. And to fold similar commits into each other. I tend to do this _after_ rebasing, so that merging is more honest with regard to my local commit history. I don't know that it plays a huge part in making the merge conflicts easier, though.

You can tell histedit to address only your outgoing commits.

```
hg histedit -o
```

So, you can push fewer coherent commits instead of the dozens of small commits that you've been making throughout your daily work. You are making many small commits, right ;) Histedit is more of an art than a science. You don't have to use it right away.

The only rule is

> It's absolutely unwise, inappropriate, and downright dangerous to edit pushed, public history.

A note for .NET users 

> Both `rebase` and `histedit` remove and replay commits locally. If you have a solution open in Visual Studio, it will get cranky, warning about changes and prompting you to reload files or projects. I suggest closing the solution beforehand.

## A Sample Workflow with Screenshots!

Let's take a look at some screenshots of a rebase/histedit workflow that I performed recently. Lot's of public changes coming in.

```
hg incoming
```

{% img /images/straight-line-development/03-incoming.png %}

An easy rebase, I was working in another part of the system.

```
hg pull --rebase
```

{% img /images/straight-line-development/04-pull-rebase.png %}

A few local commits to go out.

```
hg outgoing
```

{% img /images/straight-line-development/05-outgoing.png %}

Fold them all into one another.

```
hg histedit -o
```

{% img /images/straight-line-development/06-histedit.png %}
{% img /images/straight-line-development/07-histedit-start.png %}

Now, only one going out.

```
hg outgoing
```

{% img /images/straight-line-development/08-outgoing-done.png %}

And it's on its way!

```
hg push
```

## Feature/Bugfix Branching
You asked for it. Feature branches let you switch back to default and do hotfixes or pull remote changesets without messing with your work-in-progress. Mercurial does a few tricky things when pushing with new branches that other systems may not. So, pay attention. The workflow should integrate just fine with rebase. Let's start a new branch.

```
hg branch feature/import-big-layout
```

{% img /images/straight-line-development/09-branch.png %}

Work on your feature until completion. When you're done and ready to synchronize, send this special commit. It tells Mercurial that your branch is no longer active.

```
hg commit -m "done" --close-branch
```

It's at this point that I like to `histedit` my feature branch. I can fold the close commit into the previous (it's not very interesting on its own). Merge the feature branch back into default. Then, follow the rebase guidance on default.

```
hg up default
hg merge feature/import-big-layout
```

{% img /images/straight-line-development/10-up-merge.png %}

Now, when we try to push, we get a scary alert.

> abort: push creates new remote branches

```
hg push
```

{% img /images/straight-line-development/11-push.png %}

What are we supposed to do with that? You could push default explicitly. 

```
hg push default
```

But, that's going to get annoying over time. Go ahead and push your new branch. It may be unnecessary, but it shouldn't offend anyone. The close commit should ensure that you only get bothered about this once.

```
hg push --new-branch
```

You'll see your feature branch break off of default and merge back, but it's self contained and still leaves default in a straight line.

{% img /images/straight-line-development/12-commit-graph.png %}

I shouldn't have to warn you about this now, but if you ever do push your feature branch to the server, to collaborate or whatever, don't edit its history (always use the `--outgoing` option of `histedit`). The workflow should still work out in the end.


 [1]: http://mercurial.selenic.com/wiki/RebaseExtension
 [2]: http://mercurial.selenic.com/wiki/HisteditExtension
 [3]: https://github.com/AnthonyMastrean/anthonymastrean.github.com/tree/master/images/straight-line-development