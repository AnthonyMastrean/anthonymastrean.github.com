---
layout: post
title: "Event Handling Styles in Event Sourcing"
date: 2011-10-20 00:00
comments: true
categories: event-sourcing
---

*This is the a reprint of an email thread I had with [Dennis Kozora][djk] many moons ago. I had to get it out of my head. Anymore, I recommend just using [CommonDomain][cd].*

----

A domain object in an event sourcing architecture must react to commands occurring *now* and to events being *replayed* from the event stream. So, the logic must be called from two places (for example, when making a customer preferred). So we put that logic in a method and make sure to call it from the `MakeCustomerPreferred` method of the `Customer` and the `ReplayEvents` method of the base `Entity`.

`DelegateAdjuster` was a [nasty approach][del] used by Greg Young. Here is a list of a few other implementations...

## Domain Event Handler

    var handler = (IDomainEventHandler<TDomainEvent>)this; 
    handler.Handle(domainEvent); 
    pros: explicit contract

**Cons:** 

* exposes the handler method publicly
* requires additional interface ceremony

## Dynamic Event Handler

    dynamic obj = this; 
    obj.Handle(domainEvent); 
    
**Pros:**

* simple: no reflection, no interfaces

**Cons:**

* protection level must be public
* requires ref. to `Microsoft.CSharp` assembly (for the `dynamic` keyword)

## Reflection

    var methodName = string.Format("On{0}", domainEvent.GetType().Name); 
    var methodInfo = GetType().GetMethod(methodName, BindingFlags.Instance | BindingFlags.NonPublic); 
    methodInfo.Invoke(this, new object[] { domainEvent }); 

**Pros:**

* explicit convention

**Cons:**

* uses reflection
* difficult to refactor

## Explicit Handler Registrations
In the subclass ctor; base class handles the collection of registration of handlers.

**Cons:**

* requires author to remember to explicitly register the handlers
* because its in the ctor, the handlers will be registered every time one is created

## Bootstrap
Configure the handlers once, by convention, using reflection. Let the event coordinator resolve the handler by selecting it from the list of registered handlers for the type.

 [djk]: https://twitter.com/#!/djkozora
 [cd]: http://nuget.org/packages/CommonDomain
 [del]: http://codebetter.com/gregyoung/2009/10/03/delegate-mapper/