# anthonymastrean.com

[![Build Status](https://img.shields.io/travis/AnthonyMastrean/anthonymastrean.github.com.svg?branch=source&style=flat-square)](https://travis-ci.org/AnthonyMastrean/anthonymastrean.github.com)

## Local Development

Octopress 3.0 and Jekyll 2.0 seem to work on a vanilla Windows machine now! Install these prerequisites

```
$ choco install --yes ruby ruby2.devkit nodejs
```

Install the site prerequisites, using Bundler, and build or serve the site using Jekyll.

```
$ bundle install
$ bundle exec jekyll serve
```

## Vagrant

Install Vagrant and VirtualBox.

```
$ choco install --yes vagrant virtualbox
```

Boot the Vagrant box, allowing it to provision with Puppet.

```
$ vagrant up
```

And build or serve the site using Jekyll remotely on the box.

```
$ vagrant ssh --command 'cd /vagrant && bundle install && bundle exec jekyll serve'
```

## Updating the Engine

_(Update instructions for Octopress 3.0!)_

## Deploying

Via Octopress (as long as a `_deploy.yml` is available, after an `octopress deploy init git <URL>` call)

```
$ octopress deploy
```

## Travis CI

Or, just commit and let Travis-CI handle the rest (not reimplemented for
Octopress 3.0).
