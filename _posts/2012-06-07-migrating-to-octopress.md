---
layout: post
title: "Migrating to Octopress!"
date: 2012-06-07 13:28
---

A coworker had recently moved her family blog from WordPress to [Octopress](http://octopress.org/). I already migrated from Google Sites to Blogger to Tumblr, ugh! I was fed up and wanted to control my content and own my own platform.

I use [Ruby for Windows](http://rubyinstaller.org/), the [Ruby DevKit](http://rubyinstaller.org/add-ons/devkit/), and PowerShell. You do not _need_ a Ruby version manager to install Octopress. There is no great alternative for Windows users, anyway. You can get these all setup and configured using [Chocolatey](http://chocolatey.org). If the DevKit is not properly installed and configured, `bundle install` will fail to build certain gems.

Deploying to GitHub:Pages was not fool-proof. Your GitHub user page is just a repository called `<username>.github.io`. GitHub then knows that it should render any `index.html` in the root of that repository. If you create the wrong repository and try to visit the address, you'll get a 404.

Octopress's Rake tasks for configuring, generating, and deploying your site are generally ok. However, the setup task, `rake setup_github_pages`, asks for your "GitHub Pages repository URL". That means the _SSH_ URL, the one that start with   `git@github.com`. If you enter the wrong URL, you get a useless Rake error.

I plan to continually edit and expand posts. So, I removed the date portion of the post permalink resulting in `permalink: /blog/:title/`. I don't intend to enable many widgets, I think text is the future of the web ;)
