# anthonymastrean.com
[![Build Status](https://img.shields.io/travis/AnthonyMastrean/anthonymastrean.github.com.svg?branch=source&style=flat-square)](https://travis-ci.org/AnthonyMastrean/anthonymastrean.github.com) [![Gittip](https://img.shields.io/gratipay/anthonymastrean.svg?style=flat-square)](https://www.gratipay.com/AnthonyMastrean/)

## Local Development

The provided Vagrant machine will have all of the development dependencies installed. You just have to generate, start the preview engine, and browse to the forwarded address: [http://localhost:4000/](http://localhost:4000/).

```
$ vagrant up
$ vagrant ssh --command 'pushd /vagrant && bundle exec rake generate preview'
```

## Updating

To [update](http://octopress.org/docs/updating/) Octopress

```
$ git pull --no-rebase octopress master
$ vagrant up
$ vagrant ssh --command 'pushd /vagrant && bundle exec rake update'
```

## Deploying

The Vagrant machine is not setup with git or SSH keys or personal tokens. You can generate & preview the site and must commit for the Travis-CI build to complete the push.

