---
layout: page
title: "Resume"
date: 2014-08-08 00:00
comments: true
sharing: true
footer: true
---

> I am an expert Windows platform developer practicing zero friction software development. My goal is to be "done, and gets things smart". I believe that automated testing, continuous integration, and scripting "everything" is going to change the world of Windows development.

 * [Experience](resume#experience)
 * [Education](resume#education)
 * [Certifications](resume#certifications)

# Experience

## Software Engineer, Rough Stone Software
_2013 - 2013_

As part of a professional services company, I maintained ASP.NET MVC legacy websites, using NHibernate and Entity Framework, communicating mostly via WCF web services and SQL Server database.

## Software Engineer, Omnyx
_2010 - 2013_

My team developed the software for a microscope slide scanner, from the touch screen interface to the hardware control. We operated as a "rescue project," balancing speed of delivery and quality. We pair programmed, practiced BDD, and invested in continuous deployment.

 * The scanner ran a touch screen WPF application from an internal PC that communicated with motors, sensors, and robotics hardware via USB, ethernet, and serial ports. It used a sophisticated, in-process, multithreaded queuing system (using the TPL). The system ran without a database, using JSON blobs on disk and communicating with the backend systems via WCF web services.

 * We passed all regulatory milestones and supported automated instrument configuration & calibration in manufacturing and as part of customer shipping & receiving.

 * We implemented a patented dual-sensor, automatic focusing scanning system with near-real time image acquisition, processing submillimeter regions of tissue at submicron accuracies.

 * We completed development of the continuous loading model of the product which featured a custom 5-axis robotic arm and a 120-slide loading area.

## Test Automation Engineer, Omnyx
_2009 - 2010_

I focused on test automation tools & techniques, specifically as a development responsibility.

 * The product was multiple WPF desktop applications using Unity, MVVM, and WCF services, communicating with a .NET server backend that used NHibernate, NServiceBus, and a SQL Server database.

 * I developed the first automated smoke tests and integrated them into the nightly build.

 * I evangelized context/specification-style acceptance testing among the teams. We developed 100s of automated tests for our desktop application. We built a "headless" framework for test-driving our WPF application.

 * Our systems engineer and I developed load- and system-testing tools and scenarios, to be deployed into an HP load testing lab, to support release entrance. We connected and orchestrated the actions of 10s of "users" through various network configurations to a fully scaled system with petabytes of storage.

## Software Engineer, FedEx Ground
_2007 - 2009_

We developed mobile, web, and mainframe software that supported the pickup & delivery of over 3 million packages a day. We acted as FedEx's mobile development center of excellence, guiding teams across the nation.

 * The total application platform was Windows mobile/CE handheld devices, using the .NET compact framework, running local SQL Express databases, with WCF web services and mainframe systems communicating via messaging.

 * We processed 100s of thousands of digital signatures per day, sent to our servers over the cellular networks from mobile scanners, moving them through mainframe and web systems to supply near real time delivery confirmation.

 * We provided a "smart" update system so that 10s of thousands of mobile scanners could check-in and download the latest settings and corporate data to support their daily pickup & delivery activities.

 * We merged millions of US & Canadian postal addresses, published monthly, with internal facilities management and routing data, published weekly, so that the pickup & delivery applications were always fine tuned for their geographic location.

## Intern (Help Desk & QA), FedEx Ground
_2004 - 2007_

I automated help desk tasks, mostly on IBM mainframes, reducing manual interaction time from 10s of minutes a day for each member of the team, down to seconds. I similarly automated mobile device testing and mainframe test oracles.

## Speaker, Software User Groups
_2010 - 2011_

 * From 2010 to 2013, I have talked to the local .NET user group about practical log4net, advanced Windows scripting with PowerShell, and contributing to open-source software using git and github. I have also started speaking to the newly-formed PowerShell user group on advanced profile and module management.

 * Throughout 2010 and 2011, I presented an hour long session on CQRS and event sourcing at .NET code camps in Pittsburgh, Roanoke, and Philadelphia.

 * In 2013, I am returning to Philadelphia to present an hour long session on automating tasks and writing build scripts for .NET solutions using the Rake, the Ruby-based build program.

# Education

## Software Engineering, Robert Morris University
_2003 - 2007_

I graduated with honors and earned a minor in Mathematics. My graduating class helped the engineering school achieve ABET accreditation through participation in verification activities. I chaired the RMU Student Chapter of the ACM and led teams at the CMU Invitational Programming Competition.

## Student, Greg Young's CQRS Course
_2010 - 2011_

Young introduced the concepts of CQRS, DDD, and event sourcing. He analyzed the difference between business concurrency and version concurrency problems and solutions. Young explained super-low-latency event storage (high frequency stock trading) and other large scale high reliability strategies.

# Certifications

## CSDA, IEEE
_2008 - 2008_

## EIT (PA), NCEES
_2007 - 2007_
