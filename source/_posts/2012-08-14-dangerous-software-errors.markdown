---
layout: post
title: "Dangerous Software Errors"
date: 2011-07-09 00:00
comments: true
categories: errors practices principles
---

In 2009, I responded to a professor at my alma mater about the list of [top software errors][err].

> A lot of these problems are negated or heavily mitigated by the application of modern programming languages and mature infrastructure (rather than by manual implementation of the advice given in the article).

Let's see what I wrote, if it makes any sense, and maybe I'll write up a response to the 2011 list! I organized this article by response and then listed each item that is addressed beneath it.

## Managed Code
Managed code seems to avoid all of these problems, either by actually solving the problem or avoiding it by building in guard code.

* CWE-120 Buffer Copy without Checking Size of Input ('Classic Buffer Overflow')
* CWE-78 Improper Sanitization of Special Elements used in an OS Command ('OS Command Injection')
* CWE-805 Buffer Access with Incorrect Length Value
* CWE-129 Improper Validation of Array Index
* CWE-190 Integer Overflow or Wraparound
* CWE-131 Incorrect Calculation of Buffer Size

It's wild that PHP has an exclusive item on this list, but I guess [it doesn't matter][php].

* CWE-98 Improper Control of Filename for Include/Require Statement in PHP Program ('PHP File Inclusion')

## Web Frameworks
The following problems can be mitigated by sanitized HTML input/output. And also by encouraging best practices through the use of conventions (use ASP.NET MVC, FubuMVC, etc).

* CWE-79 Failure to Preserve Web Page Structure ('Cross-site Scripting')
* CWE-352 Cross-Site Request Forgery (CSRF)
* CWE-807 Reliance on Untrusted Inputs in a Security Decision
* CWE-601 URL Redirection to Untrusted Site ('Open Redirect')

## ORMs
ORMs, like NHibernate, use parameterized SQL.

* CWE-89 Improper Sanitization of Special Elements used in an SQL Command ('SQL Injection')

## Logging Framework
Use a modern logging framework (log4net) that allows you to filter input and output to different sinks.

* CWE-209 Information Exposure Through an Error Message

## CQRS
Security frameworks are awkward or weak (see [Rhino Security][sec] for a simple example). Applications built on a service bus (see CQRS) can pass every message through a security handler first.

* CWE-285 Improper Access Control (Authorization)
* CWE-306 Missing Authentication for Critical Function

Separate your application using CQRS and service-bus patterns. Performance becomes highly local and highly configurable.

* CWE-770 Allocation of Resources Without Limits or Throttling

Threading is hard. Understand concurrency and parallelism. CQRS and service-bus patterns can help you avoid or flatten threading in your application (you should see by now that CQRS can do anything).

* CWE-362 Race Condition

## Practices
These errors seem to me to be solved only through diligent practice and application of good coding practices.

* CWE-22 Improper Limitation of a Pathname to a Restricted Directory ('Path Traversal')
* CWE-434 Unrestricted Upload of File with Dangerous Type
* CWE-311 Missing Encryption of Sensitive Data
* CWE-798 Use of Hard-coded Credentials
* CWE-754 Improper Check for Unusual or Exceptional Conditions
* CWE-494 Download of Code Without Integrity Check
* CWE-732 Incorrect Permission Assignment for Critical Resource

The provided solution is a good one, "Use a good library".

* CWE-327 Use of a Broken or Risky Cryptographic Algorithm

 [err]: http://www.sans.org/top25-software-errors/2009/
 [php]: http://www.codinghorror.com/blog/2008/05/php-sucks-but-it-doesnt-matter.html
 [sec]: https://github.com/ayende/rhino-security
