---
layout: post
title: "Interview with a Ruby Shop"
date: 2013-10-24 00:00
---

Interview questions for a small, local Ruby shop.

### Do you have any experience programming in Ruby? If so, please describe.

I wrote and primarily maintain the Rake build for our .NET solution. We must be able to pull any released version of the software out of the repository and re-build it (for regulatory reasons). We were using TeamCity's built-in runners, but were unable to store them with the code or audit it properly. Developing a Rake build allowed us to checkin the build script with every branch and release.

We used the Albacore rake tasks for .NET from Derick Bailey. We contributed an MSTest task (which was pulled in) and an MSBuild task extension (waiting in a pull request). I wrote some more .NET specific [application metadata/configuration tasks][2] (pull request coming later) and a [simple deploy task][3]. Both of these have been published to RubyGems.

  [2]: https://github.com/AnthonyMastrean/FileUpdateTasks
  [3]: https://github.com/AnthonyMastrean/LocalDropTasks

My recent involvement in the Albacore project led me to request ownership from Derick Bailey. I organized the remaining active developers (Henrik Feldt and Jeff Schumacher) and created the [Albacore organization][4]. We've fixed some bugs, pulled in some code, and recently published a new version of the gem.

  [4]: https://github.com/Albacore

### Describe your experience with object-oriented design.

I'm a SOLID guy at heart. I believe that several of these principles transcend static/dynamic functional/procedural paradigms, namely: SRP, OCP, and ISP. SRP is at the heart of what we do though and ["extract method"][5] is my hammer. This principle has led me down a path toward functional programming patterns. "Do one thing" is strict. An algorithm and how I execute that algorithm are two different things and can (_should?_) be separated.

  [5]: http://blog.objectmentor.com/articles/2009/09/11/one-thing-extract-till-you-drop

OCP is a tough one and some languages give you just enough rope to hang yourself (mixins, multiple inheritance). I favor composition of components instead. It's harder to mix state with composition. And easier to mock, test, and swap components this way. I think this has leaked into every level of my thinking. I think about the way I "close" namespaces, assemblies, and even higher, packages (think gems).

ISP has a sorry history in static language ecosystems. Interfaces should allow us to interact with objects based on [what they do][6], not on how they do it. The canonical example makes me cringe

```
Cat : IAnimal {
  void Speak() { Console.WriteLine("meow"); }
}
```

The "correct" implementation is in the describing a behavior that I can perform, not a noun that I am!

```
Cat : ICanSpeak {
  void Speak() { Console.WriteLine("meow"); }
}
```

This principle has led me down the path of behavior driven development even in my unit tests. I try to ignore the "how" (usually, by [extracting][7] and then testing the new "what") and focusing on the "what".

  [6]: http://simpleprogrammer.com/2010/11/02/back-to-basics-what-is-an-interface/
  [7]: http://www.anthonymastrean.com/blog/eradicating-non-determinism-in-tests/

Let's not forget primitive obsession, which I've kicked! I won't bore you here, but you can check out what I've [already written][8].

  [8]: http://www.anthonymastrean.com/blog/primitive-disinterest/

### Describe your professional passions, things that make you happy in your profession.

Great teams are passionate and expert at their craft. When empowered to make decisions, they will blow through barriers and accomplish amazing things. If you have a team like this, trust them, and unleash them on your business! Projects and companies succeed or fail not due to technical problems/expertise, but due to people. I'm a culture geek and this means a lot to me.

That said, I really like teaching and speaking to other developers and learning from them alike. I like "brown bag" meetings and encourage participation in local groups. Open spaces events are like rocket fuel to me. I think developers need to learn to speak in public or at least _to_ the public. Blog or tweet!

This goes hand-in-hand with participating in open source, from submitting bugs or answering questions on StackOverflow to sending pull requests. Everyone can get involved in some meaningful way.

### Describe for us areas you'd like to grow in professionally.

I'd like to get some experience in *nix systems. I'm an automation nut and have been using PowerShell and AutoHotkey on the Windows platform. But, I feel like it's a generation or so behind. I also want to push the envelope on my devops skills. I've been configuring and deploying desktop applications on Windows in a regulated enviornment. You can only get so "continuous" with that process before there are gates to pass or manual pushes.

I want to continue growing in OSS contributions and, ultimately, leadership. I'll be kind of conflicted leaving a .NET shop just as I help take over Albacore! But, I know this will reveal other opportunities. The OSS community on other platforms seems to be more mature.

Last, but not least, is my desire to really grok functional programming paradigms. That world has great ideas, but they don't do themselves any favors with the way it's presented (>>=, anyone?). It's possible to learn and practice immutable objects and pure functions in any language.
