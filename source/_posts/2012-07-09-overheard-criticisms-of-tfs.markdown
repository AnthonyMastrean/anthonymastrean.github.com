---
layout: post
title: "Overheard Criticisms of TFS"
date: 2011-05-18 18:17
comments: true
categories: tfs
---

{% blockquote Dennis Kozora, https://twitter.com/djkozora %}
We need to get this organization off of the TFS crack!
{% endblockquote %}

* It uses a check-out/check-in model
* It's unusable if you are disconnected from the server
* It has no native rollback function (it may be able to issue a compensating changeset)
* Shelvesets will burn you if you aren't careful
* Branching is slow and painful
* TeamBuild is a joke compared to TeamCity
* Installation and configuration is a nightmare
* We had to hire a TFS consultant to restore our TFS instance for a disaster recovery simulation
* TFS cannot be considered a serious code repository when it does NOT adequately support rollback/revert to a previous version
* Merging. TFS merging is stupid, literally. It cannot adequately resolve merging issues that other products resolve seamlessly.
* TFS is NOT a DVCS
* TFS demands a network connection. What little offline support it provides creates a tremendous amount of friction: long wait periods when loading a solution in offline mode, weird behavior when switching back to online mode
* VS TFS addin, TF commands, TFPT commands … how many tools do I need? Which ones should I use when?
* Workspaces! The concept of a workspace is ridiculous.