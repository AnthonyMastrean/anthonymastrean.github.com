---
layout: post
title: "Dashboarding"
date: 2015-06-10 00:00
---

All I wanted was a huge TV hanging above our workspace displaying the build server status page. Too much to ask from the enormous IT market in 2015? Apparently.

We bought a 50" [Panasonic LED TV](http://panasonic.net/prodisplays/download/pdf/specsheet/TH-50LFE7U.pdf) (thankfully, with a generous corporate discount). The facilities folks eventually hung it on the wall and provided a quad power outlet and a network drop for whatever device we were going to tuck up there.

I thought we would just plug in a Chromecast and browse to our build status page. Haha, you have to be kidding me! You can't just run a browser. Neither can the Amazon Fire TV Stick, Roku, or Apple TV. The Amazon Fire TV supports a browser, but only if you enable developer side-loading and want to run Mozilla Firefox unsupported.

Don't forget, you might need to authenticate to your wifi network via [captive portal](https://en.wikipedia.org/wiki/Captive_portal). The Amazon Fire TV has that feature now and some of the other boxes will be getting support later.

You need a third-device "casting" to the dongle full-time!

 1. TV
 2. Chromecast (or similar)
 3. The device that's actually doing the work :(

There are a variety of reasons not to do that...

 * Don't want to remember to login to see the dashboard
 * Don't want to leave a desktop session live and running all day (security)
 * Don't want a reboot for Windows updates to take down the dashboard

The "set-top" box category of devices are letting us down. So, we're looking for some kind of full-blown PC in a mini-box. Maybe the [Asus Chromebox](https://www.asus.com/us/ASUS_Chromebox/)? Nope, it's running ChromeOS, which can't be authorized to connect to the corporate network.

The guest network doesn't have permission to access the dashboard without a firewall rule exception request.

:'(

So, now we have a $1000 black rectangle hanging on the wall. I'll let you know what ends up working.

## Caveats

 1. The corporate network requires domain authentication and/or some kind of device registration that requires meeting some arcane security measures.
