---
layout: post
title: "Budding Codebases"
date: 2012-08-05 12:28
comments: true
categories: open-closed tfs
---

[Michael Feathers][mf] wrote about [festering and budding codebases][post] last year. Festering code bases have code inserted into existing classes and methods. While budding code bases have new classes and methods created. This is the essence of the [open][ocp1]-[closed][ocp2] [principle][ocp3].

> Software entities should be open for extension, but closed for modification

Recently, Feathers showcased a query you can make against your version control system to show the [budding and festering code][g1] in your system. Basically, plot each file against the number of check-ins on that file. In this way, you can look at the right side of the chart and start asking why those files are modified so often. Please read the Feathers article completely for other benefits!

We use TFS at work, which has a [PowerShell snap-in][tfs-ps] to perform queries. I started with someone else's example of retrieving every changed file. And I simply grouped them by path and displayed the count.

```
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.TeamFoundation.VersionControl.Client") | Out-Null
$filter = [Microsoft.TeamFoundation.VersionControl.Client.ChangeType] "Add, Edit, Rename"
Get-TfsItemHistory *.cs -Recurse -IncludeItems `
    | Select-Object -Expand "Changes" `
    | Where-Object { ($_.ChangeType -band $filter) -ne 0 } `
    | Select-TfsItem `
    | Group-Object Path `
    | Select-Object Count, Name `
    | Sort-Object Count -Descending 
```

I queried one of our toughest releases, which had a high defect count and ended up needing a lot of hardening sprints (ugh). The data showed that 2% of the files were responsible for 20% of check-ins.

{% img /images/budding-codebases/budding.png %}

These charts seem to have exponential curves. In this project, 10 files were responsible for the top 5% of the check-ins. I'm really into this chart. It supports our engineering principles, is actionable, and seems to be more valuable than other reports (like cyclomatic complexity).

 [mf]: https://twitter.com/mfeathers
 [post]: http://michaelfeathers.typepad.com/michael_feathers_blog/2010/06/festering-code-bases-and-budding-code-bases.html
 [ocp1]: http://www.objectmentor.com/resources/articles/ocp.pdf
 [ocp2]: http://msdn.microsoft.com/en-us/magazine/cc546578.aspx
 [ocp3]: http://c2.com/cgi/wiki?OpenClosedPrinciple
 [g1]: http://michaelfeathers.typepad.com/michael_feathers_blog/2011/01/measuring-the-closure-of-code.html
 [tfs-ps]: http://rkeithhill.wordpress.com/2008/11/11/team-foundation-powershell-pssnapin-in-october-team-foundation-power-tools-drop/