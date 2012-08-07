---
layout: post
title: "Primitive Disinterest"
date: 2012-08-07 00:50
comments: true
categories: primitive-obsession domain-driven-design
---

I've finally kicked my [primitive obsession][ob]! I didn't even know I had one until I got serious about making a type for *everything* that has a name. I'll never write a method like this again

    void MoveTo(double position)

What is position? What values of `double` are valid? Can it be negative, zero, not a number? Does it have a direction? Is it relative or absolute? Most importantly, what scale and system (English, metric, millimeters, microns)?! Not very informative, huh? `MoveTo` is an *absolute* move on a *micron* scale *linear* motor controller. What if instead we said

    void MoveTo(Distance position)

Now we have options! Let's see what the `Distance` type looks like

```
public class Distance : IEquatable<Distance>
{
    private const int MicronsPerMillimeter = 1000;

    public static readonly Distance None = new Distance(double.NaN);
    public static readonly Distance Zero = new Distance(0);

    public static Distance FromMicrons(double microns) { return new Distance(microns); }
    public static Distance FromMillimeters(double millimeters) { return new Distance(millimeters * MicronsPerMillimeter); }

    public double TotalMicrons { get; private set; }
    public double TotalMillimeters { get; private set; }

    public Distance(double microns)
    {
        TotalMicrons = microns;
        TotalMillimeters = TotalMicrons / MicronsPerMillimeter;
    }

    public override string ToString()
    {
        return string.Format("{0} um", TotalMicrons);
    }

    // equality methods... GetHashCode(), Equals(obj other)
    // arithmetic operator overloads... +, -, /, *, etc
}
```

We can make intuitive extension methods for creating instances.

    10000.Microns()
    10.Millimeters()

We have properties for accessing the different scale primitives.

    _distance.TotalMicrons
    _distance.TotalMillimeters

A fancy `ToString` implementation.

    10.Millimeters().ToString() == "10000 um"

And arithmetic and equality operators galore! We can even introduce other "unit" types and work them together.

    // A `Velocity` times a `TimeSpan` equals a `Distance`
    100.MicronsPerSecond() * 10.Seconds() == 1.Millimeters()

The toughest part of propagating these simple value types is the friction you'll face in the framework. Like reimplementing the [`Math`][math] class functions (check out [units of measure][uom] in F#). Although, I can make them extension methods and give them better semantics.

    Math.Abs(double - double) 
    // or
    Distance.Between(Distance, Distance)

The arithmetic and equality operator overloading is tedious. Between the same type you'll need `+`, `-`, `/`, `*`, `<`, `>`, `==`, and `!=`. That's not to mention all the types that cancel or combine units (like `TimeSpan`, `Distance`, `Velocity`, and Acceleration`). You'll need to implement operators between these. And, where commutative properties apply, double the number of overloads!

    operator Distance *(Velocity velocity, TimeSpan timespan)
    operator Distance *(TimeSpan timespan, Velocity velocity)

And where do you put these operators, on the first or second type? Maybe this is why the framework defines no operators on these kinds of types (for instance, `Vector`, `Point`, and `TimeSpan`) but uses static methods. I think it kills the flow of the code. Compare static instantiation and arithmetic

    var distance = Velocity.PerSecond(Distance.FromMicrons(100)).DistanceAfter(TimeSpan.FromSeconds(10));

to extension methods and operator overloads

    var distance = 100.MicronsPerSecond() * 10.Seconds();

Anyone could understand the units in play and the math happening here. The flow of the extension methods and operator overloads is worth more than the weak claim of static method name clarity.

 [ob]: http://grabbagoft.blogspot.com/2007/12/dealing-with-primitive-obsession.html
 [math]: http://msdn.microsoft.com/en-us/library/system.math.aspx
 [uom]: http://blogs.msdn.com/b/andrewkennedy/archive/2008/08/29/units-of-measure-in-f-part-one-introducing-units.aspx