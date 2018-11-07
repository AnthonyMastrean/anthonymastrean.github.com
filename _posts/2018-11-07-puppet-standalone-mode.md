---
layout: draft
title: "Puppet Standalone Mode"
date: 2018-11-07 00:00
---

# Puppet "Standalone" Mode

_AKA "puppet apply" or "puppet masterless"_

We're all in over our heads with containers, but you still need to configure and control a machine (probably a VM) to _run_ Docker and to expose ports to external traffic. So, you still have to learn to use Puppet (or Chef or Ansible, they're all great, honestly). I found that the IT team isn't up to the task of running a Puppet master, too. This is not an insult, just a reality... corporate IT has their hands _full_ managing the network, devices, desktop support, etc.

So, you think you'll try running Puppet in "standalone" mode. Well... that's easier said than done and I'm not sure if it's worth it vs. learning how to run a Puppet master. But, it's the situation we're in so let's review.

## Development

Let's start with development of the Puppet manifests. We're going to trash this machine and we don't want to wait for IT to reset or restore a snapshot. So, we definitely want to start by using local VMs. Let's get started with Vagrant.

```
$ choco install -y vagrant virtualbox
```
