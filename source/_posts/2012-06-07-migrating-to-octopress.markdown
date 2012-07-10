---
layout: post
title: "Migrating to Octopress!"
date: 2012-06-07 13:28
comments: true
categories: octopress github blogging
---

I've been reading about and thinking about migrating from Tumblr to [Octopress][op] & [github:pages][ghp] (I previously migrated from Blogger and, before that, Google Sites). A coworker moved her family blog around from WordPress to Octopress and, finally, to [ruh-oh][r]. And [Scott Muc][muc] just [moved to Octopress][muc1], so I thought I should too!

I was working on Windows 7 with [msysgit][git], PowerShell (with [posh-git][pg]), and [Ruby for Windows][rb]. You do not _need_ the RVM or rbenv packages to make the [Octopress installation][op-install] work, although something like it is recommended. There is [pik][pik] on Windows, but I don't know if it's just for managing rubies or for managing gems/gemsets.

I did need to install the Ruby [DevKit][dk-dl] and I followed the manual [installation][dk-install] instructions, but there is a [chocolatey package][dk-pkg] that does all the hard work. If DevKit is not properly installed & configured, the `bundle install` will fail on certain gems.

I deployed to github:pages and had two hiccups. First, your github "user" page is started by creating a repository called `<yourusername>.github.com`. That's it! But it seems to be missing from the instructions. Github then knows that it should render any `index.html` in the root of that repository (Octopress creates this later). If you create the wrong repository and try to visit the address, you'll get a 404.

The rake tasks provided with Octopress for installing, configuring, and running your site are great. However, the second problem was with `rake setup_github_pages` for [deploying][op-setup] to the github repository. The task asks you to enter your "Github Pages repository url". And they mean the _SSH_ url, like the one for this repository  `git@github.com:AnthonyMastrean/anthonymastrean.github.com.git`. If you enter the wrong URL, you get a useless rake error.

I plan to continually edit & expand articles (like Martin Fowler does with his bliki). So, I removed the date portion of the post permalink resulting in `permalink: /blog/:title/`.  I probably won't play with widgets and such, because I don't expect many visitors to this website itself (I read 99% of my content in an aggregator).

So, that's it! Now, go forth and have fun!

 [op]: http://octopress.org/
 [op-install]: http://octopress.org/docs/setup/
 [op-setup]: http://octopress.org/docs/deploying/github/
 [ghp]: http://pages.github.com/
 [r]: http://ruhoh.com/
 [muc]: https://twitter.com/#!/scottmuc
 [muc1]: http://scottmuc.com/migrated-to-octopress/
 [git]: http://msysgit.github.com/
 [pg]: https://github.com/dahlbyk/posh-git
 [rb]: http://rubyinstaller.org/
 [c]: http://chocolatey.org/
 [pik]: https://github.com/vertiginous/pik
 [dk]: http://rubyinstaller.org/add-ons/devkit/
 [dk-dl]: http://rubyinstaller.org/downloads/
 [dk-install]: https://github.com/oneclick/rubyinstaller/wiki/development-kit
 [dk-pkg]: http://chocolatey.org/packages/ruby.devkit