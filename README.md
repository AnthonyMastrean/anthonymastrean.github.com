# anthonymastrean.com
[![Build Status](https://img.shields.io/travis/AnthonyMastrean/anthonymastrean.github.com.svg?branch=source&style=flat-square)](https://travis-ci.org/AnthonyMastrean/anthonymastrean.github.com) [![Gittip](https://img.shields.io/gratipay/anthonymastrean.svg?style=flat-square)](https://www.gratipay.com/AnthonyMastrean/)

## Local Development

The provided Vagrant machine will have all the Ruby development dependencies installed and the site generated. You just have to start the preview and browse to the forwarded address: `localhost:4000`.

```
$ vagrant up
$ vagrant ssh --command 'pushd /vagrant && bundle exec rake preview'
```
