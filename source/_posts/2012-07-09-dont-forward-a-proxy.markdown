---
layout: post
title: "Don't Forward a Proxy"
date: 2011-05-05 14:51
comments: true
categories: structuremap dynamicproxy interfaces
---

I have a class that implements two [behavioral interfaces][bi]

    class StageManager : IMoveStages, IProvideEncoderPulseScale

I [registered][smap] both interfaces to the same concrete class.

    For<IMoveStages>().Use<StageManager>();
    Forward<IMoveStages, IProvideEncoderPulseScale>();

The hardware controller, `IMoveStages`, is wrapped in error recovery logic (using [Dynamic Proxy][dyn] and the StructureMap DSL)

    IfTypeMatches(type => typeof(IMoveStages)
        .IsAssignableFrom(type))
        .InterceptWith((ctx, target) => 
            _proxyGen.CreateInterfaceProxyWithTarget(
                target, 
                new RecoveryInterceptor()));

However, when I resolve `IProvideEncoderPulseScale`, I get `null`! Allow me to fast-forward past the debugging...

I told Dynamic Proxy to proxy the concrete that was resolved for `IMoveStages`. So we get something like `class MoveStages_Proxy : IMoveStages`. StructureMap tried to forward the resolution of `IProvideEncoderPulseScale`, but the proxy only implements `IMoveStages`! Only the proxy's _target_ implements both interfaces.

I implemented the quick fix and chained the interface declarations

    interface IMoveStages : IProvideEncoderPulseScale

The real solution is to instruct Dynamic Proxy to [proxy the target and all its interfaces][i], but only intercepting the actual target interface. Krzysztof's post shows how to do it "manually". But, I have a system-wide interceptor that goes on a few dozen interfaces/targets. I don't want to specify every additional interface on every target explicitly.

    // not sustainable!
    _proxyGen.CreateInterfaceProxyWithTarget(
        target, 
        new[] { typeof(IProvideEncoderPulseScale) }, 
        new RecoveryInterceptor())

I think that some reflection like this would work. Get all interfaces on the target that aren't your own interface.

    var additionalInterfaces = target
        .GetInterfaces()
        .Where(interface => !(interface is target));
    
    _proxyGen.CreateInterfaceProxyWithTarget(
        target, 
        additionalInterfaces, 
        new RecoveryInterceptor());


 [bi]: http://simpleprogrammer.com/2010/11/02/back-to-basics-what-is-an-interface/
 [smap]: https://github.com/structuremap/structuremap
 [dyn]: http://www.castleproject.org/projects/dynamicproxy
 [i]: http://kozmic.pl/2009/07/01/castle-dynamic-proxy-tutorial-part-xi-when-one-interface-is
