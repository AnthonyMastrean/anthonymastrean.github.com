---
layout: post
title: "StackOverflow DevDays 2009"
date: 2012-07-09 22:06
comments: true
categories: stackoverflow opinions iphone mvc convention estimation jquery dynamic agile
---

_I attended the [StackOverflow DevDays][devdays] conference in Washington, DC in October 2009. Also see the official [notes round-up][notes]._

<hr/>

## Keynote: [Joel Spolsky][spolsky] on Software Design and Development
The scale of "Simplicity vs Power" was introduced, with reference to the [Pareto Principle][pp]. He contrasted "[less is more][37s]" vs delivering [features][opts]. But it was too naive, those things aren't exclusive.

So the scale of "Good Features" and "Bad Features" was proposed. In particular, what do people [care about][care] vs [controlling the user][uac]. Particularly, you shouldn't ask your user to make a decision they are unqualified to make! That is a failure to design.

The end point was that features (and code) should be elegant. **Elegance is the modesty to not draw attention to the challenges that have been surmounted.** Read more about [opinionated software][op].

 [devdays]: http://www.amiando.com/stackoverflowdevdays-washingtondc.html
 [notes]: http://meta.stackoverflow.com/questions/27367/devdays-2009-reviews-washington-dc
 [spolsky]: http://www.joelonsoftware.com/
 [pp]: http://en.wikipedia.org/wiki/Pareto_principle
 [37s]: http://37signals.com/
 [opts]: http://grabbagoftimg.s3.amazonaws.com/testdriven.PNG
 [care]: http://www.jwz.org/doc/groupware.html
 [uac]: http://www.reed.edu/cis/help/images/vistaImages/uac_prompt.jpg
 [op]: http://gettingreal.37signals.com/ch04_Make_Opinionated_Software.php

## [Dan Pilone][pilone] on iPhone [Development][ios] [Strategy][tap]
The main idea is that you aren't going to get rich quick, but there is money to be earned. You have a small space (physically and in resources) and a short time to make an impression (average user uses an application for 6 minutes). Apple is strict about violations of the [HIG][hig] or IP. The approval process takes 2 weeks whether an app is accepted or rejected.

 [pilone]: https://www.google.com/search?q=%22dan+pilone%22+iphone
 [ios]: https://developer.apple.com/devcenter/ios/index.action
 [tap]: http://taptaptap.com/blog/
 [hig]: http://developer.apple.com/library/mac/#documentation/UserExperience/Conceptual/AppleHIGuidelines/Intro/Intro.html
 
## [Scott Allen][allen] on [ASP.NET MVC][mvc]
Microsoft's answer to [Ruby on Rails][ror], [Django][dj], and the [webforms problem][wf] in general. The technical bits are solid and all available online. The real takeaway here was [Convention][coc1] [Over][coc2] [Configuration][coc3].

 [allen]: http://odetocode.com/blogs/scott/
 [mvc]: http://www.asp.net/mvc
 [ror]: http://rubyonrails.org/
 [dj]: https://www.djangoproject.com/
 [wf]: https://www.google.com/search?q=webforms+suck
 [wf]: https://www.google.com/search?q=webforms+suck
 [coc1]: http://en.wikipedia.org/wiki/Convention_over_configuration
 [coc2]: http://ayende.com/blog/2777/convention-over-configuration-structured-approach
 [coc3]: http://msdn.microsoft.com/en-us/magazine/dd419655.aspx
 
## Joel Spolsky on [FogBugz][fbz]
His focus was on its key feature, [Evidence Based Scheduling][ebs] (taking into account not just velocity, but accuracy in estimation). One of the major takeaways was this advice on estimation.

{% blockquote %}
If your task is estimated in days, you have no idea what you're building. Break it down until you've got an estimate of hours.
{% endblockquote %}

 [fbz]: http://www.fogcreek.com/fogbugz/
 [ebs]: http://www.joelonsoftware.com/items/2007/10/26.html
 
## [Jonathan Blocksom][blocksom] on [Google App Engine][gae]
The [Google Moderator][mod] app was built on the GAE (used in the 2008 elections!). It's a "cloud" application hosting service. You've got access to Google's [BigTable][btable] (soon to be [MegaStore][mstore]) for data but no filesystem. The whole service is throttled and managed unless you pay for higher caps (rule of thumb, you have <1000 of everything without paying).

 [blocksom]: https://twitter.com/jblocksom
 [gae]: https://developers.google.com/appengine/
 [mod]: http://www.google.com/moderator/#0
 [btable]: http://research.google.com/archive/bigtable.html
 [mstore]: http://perspectives.mvdirona.com/2008/07/10/GoogleMegastore.aspx
 
## [Rich Worth][worth] on [jQuery][jquery]
{% blockquote %}
It changes the way you write JavaScript.
{% endblockquote %}

Like CSS separated content and presentation, jQuery separates content and behavior. You can include the jQuery library from [Google's][jq-goo] or [Microsoft's][jq-msft] hosted address (it's likely that clients already have it cached).

 [worth]: http://rdworth.org/blog/
 [jquery]: http://jquery.com/
 [jq-goo]: http://jquery-howto.blogspot.com/2008/12/let-google-host-your-jquery-library.html
 [jq-msft]: http://jquery-howto.blogspot.com/2009/09/host-jquery-on-microsoft-cdn-servers.html

## [Bruce Eckel][eckel] on Language Evolution and Philosophy
He said developers are 10x more productive in a dynamic language. It has to do with holding a problem in your head (dynamic languages are often more terse and have less structure, you can think about the code and the problem 1-to-1). And near the end, he talked about solving threading problems with dynamic languages (paying close attention to the difference between [concurrency and parallelism][conc]).

 [eckel]: http://en.wikipedia.org/wiki/Bruce_Eckel
 [conc]: https://blogs.oracle.com/yuanlin/entry/concurrency_vs_parallelism_concurrent_programming
 
## [Dave from OPower][dave] on Improving Sprints
The idea is that, for continuous improvement, you select one bad metric and target it.

1. Start by tracking the metric (defects, code coverage) in the context of story points (the size of the iteration is a good measure with meaning).
2. Make a hypothesis about a process/tool that will fix the problem or improve the measurement ("pair programming will reduce defects" or "TDD will increase test coverage").
3. Experiment! (perform the next sprint, with the process/tool you hypothesized).
4. Compare the metrics.

 [dave]: http://www.opower.com/