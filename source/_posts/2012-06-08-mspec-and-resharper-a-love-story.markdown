---
layout: post
title: "MSpec &amp; ReSharper: A Love Story"
date: 2011-04-18 21:45
comments: true
categories: mspec resharper productivity
---

[MSpec][m] is my test framework of choice. I really like the [style of test][bdd] that it encourages (which is the topic for another post altogether). But, by default, there's a lot of complaining by ReSharper. Who wants to see their lovely spec

``` 
[Subject("My service")]
public class When_my_service_is_frobbed
{
    Because of = () => subject.Frob();
    It should_call_the_proxy = () => { ... ; };
}
```

become this monster

```
[Subject("My service")]
public class When_my_service_is_frobbed
{
    private Because of = () => subject.Frob();
    private It ShouldCallTheProxy = () => 
        {
            ... ;
        }
}
```

First, ReSharper warns you that your spec classes are unused. These are any class with a `Subject` attribute. You can turn that behavior off with R# code annotations.

 1. Open the ReSharper Options (ReSharper | Options...)
 2. Select "Code Annotations" (under Code Inspection)
 3. Ensure that the namespace "Machine.Specifications.Annotations" is checked
 4. Click "OK"

Second, ReSharper will complain about the naming of your spec classes and members. Luckily, MSpec provides entities that plug in to ReSharper's naming style options.

 1. Open the ReSharper Options
 2. Select "Naming Style" (under Languages | Common)
 3. Click "Advanced settings..."
 4. Click Add+

For spec classes you want public Machine.Specifications context entities to be named with the `First_upper` style. For spec members you want private static Machine.Specifications specification and supporting fields to be named with the all_lower style. I highly recommend reading [this article][m-ctx] from the author of MSpec about context base classes

Third, I prefer my anonymous method braces to line up with the arguments and to not be indented. This is completely optional :)

 1. Open the ReSharper Options
 2. Select "Formatting Style" (under Languages | C#)
 3. Select "Braces Layout"
 4. For "Anonymous method declaration", choose "At next line (BSD style)"

And

 1. Open the ReSharper Options
 2. Select "Formatting Style" (under Languages | C#)
 3. Select "Other"
 4. Uncheck "Indent anonymous method body"

Finally, there's currently no way to turn off explicit `private` scope declarations for  just one project. And I really want them on for my production code.

 [m]: https://github.com/machine/machine.specifications
 [m-ctx]: http://codebetter.com/aaronjensen/2009/10/05/a-recent-conversation-about-mspec-practices/
 [bdd]: http://dannorth.net/introducing-bdd/