---
layout: post
title: "Collective Virtual Meetings"
date: 2015-05-20 00:00
comments: false
categories: meetings culture
published: true
---

Though we don't readily admit it, the team I'm on is part of a remote organization. We have offices in multiple time zones, work-from-home folks in different states, and offshore partners. We are trying to build a culture of remote/async work even when a lot of meetings happen in this office.

One part of that is encouraging collective ownership of meetings. For example, we started holding "lightning talks". Mostly around technical topics, by developers for developers. But, everyone is invited and we've had QA folks and IT people come by and talk, too. Even managers got on board and started presenting softer topics!

I've been scheduling them, hosting the audio conference, starting the screen share, etc. But, that makes me a bottleneck. I want anyone to schedule these and for a quorum of participants to be able to start the meeting without waiting for some "official" meeting host.

Most enterprise email/calendering systems don't make this easy because you can't transfer ownership of a meeting or assign multiple owners. I'm looking at you, Outlook. So, I quit using recurring meetings. A recurrence makes it "mine" instead of "ours". I developed a nice template that anyone can copy, edit, and deploy for their instance of a lightning talk.

Your audio conference line won't start without the host. All the participants can be on the line, unable to chat, listening to _muzak_. Ugh. Not to mention, we have to "order" a conference line from our Corporate IT catalog! Virtual meeting rooms and screen sharing tools (like WebEx) have the same strong idea of single ownership. The host starts and controls the meeting. Without the host, you have no meeting, no sharing, no chat, no video, no recording.

So, here's what we do to enable and encourage collective meeting ownership (some of these are specific to our tools, but you'll get it):

 * Schedule the virtual meeting "room" for every day of the week for the longest possible period. WebEx doesn't allow a 24-hour room, so we schedule two 12-hour meetings. This allows anyone anywhere at any time to start or join a virtual meeting. WebEx now has the concept of "personal" rooms that are always available. This is another option! But, a "permanent" room allows some kind of branding or titling to make the purpose more obvious.

 * Configure the virtual meeting room so that the first participant to sign in is the "presenter". We don't want to wait for a "host" to assign presenter permissions. This also lets the presenter get started and setup their rig early.
 
 * Provide the host key/code in the meeting agenda so that any participant can claim the host role and start a recording or configure this instance of the meeting. Again, the goal is not waiting on a single designated host!

 * Similarly, provide the host audio conference key/code to all participants so that the first participant actually starts the audio conference and they're not stuck listening to hold music. It also helps to disable entry tones (the "bing" or required "say your name" part). We need to stop saying "Who's on the line?" every time!

 * Allow the participants to use as many features as possible: chat, video, notes, file transfer, etc.
 
 * Be sure to record the meeting and provide a streaming and download link, a transcript (or minutes, etc.), and any relevant notes on a wiki and as a reply to the meeting invite, so that all the participants have access.

## Mobile

If you must require a code to dial in to the audio line, most phones should support commas (soft-pause, around 2 secs) and semi-colons (hard-pause, requires you to tap a button) between the conference number and the code. For example:

```
1-800-123-4567,1234567#
```

## Recordings

You should provide the link to the downloadable recording, because who wants to stream the recording when WebEx's plugin asks for these permissions?

{% img /images/meetings/webex.png %}

If you're awesome, you'll convert the recordings to a normal format using their [recording editor](https://chocolatey.org/packages/webexeditor).
