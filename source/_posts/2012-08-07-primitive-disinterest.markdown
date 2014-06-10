---
layout: post
title: "Primitive Disinterest"
date: 2011-07-08 00:00
comments: true
categories: primitive-obsession domain-driven-design
---

I've finally kicked my [primitive obsession][ob]! I didn't even know I had one until I got serious about making a type for *everything* that has a name. I'll never write a method like this again

```csharp
void MoveTo(double position)
```

What is position? What values of `double` are valid? Can it be negative, zero, not a number? Does it have a direction? Is it relative or absolute? Most importantly, what scale and system (English, metric, millimeters, microns)?! Not very informative, huh?

If `MoveTo` were an *absolute* move on a *micron* scale *linear* motor controller, I'd rather see this 

```csharp
void MoveTo(Distance position)
```

Now we have options! Let's see what the `Distance` type looks like

```csharp
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

```csharp
10000.Microns()
10.Millimeters()
```

We have properties for accessing the different scale primitives.

```csharp
_distance.TotalMicrons
_distance.TotalMillimeters
```

A fancy `ToString` implementation.

```csharp
10.Millimeters().ToString();    //=> "10000 um"
```

And arithmetic and equality operators galore! We can even introduce other "unit" types and work them together.

```csharp
// A `Velocity` times a `TimeSpan` equals a `Distance`
var distance = 100.MicronsPerSecond() * 10.Seconds();    //=> 1 mm
```

The toughest part of propagating these simple value types is the friction you'll face in the framework. Like reimplementing the [`Math`][math] class functions (check out [units of measure][uom] in F#). Although, I can make them extension methods and give them better semantics.

```csharp
Math.Abs(double - double) 
// or
Distance.Between(Distance, Distance)
```

The arithmetic and equality operator overloading is tedious. Between the same type you'll need `+`, `-`, `/`, `*`, `<`, `>`, `==`, and `!=`. That's not to mention all the types that cancel or combine units (like `TimeSpan`, `Distance`, `Velocity`, and Acceleration`). You'll need to implement operators between these. And, where commutative properties apply, double the number of overloads!

```csharp
operator Distance *(Velocity velocity, TimeSpan timespan)
operator Distance *(TimeSpan timespan, Velocity velocity)
```

And where do you put these operators, on the first or second type? Maybe this is why the framework defines no operators on these kinds of types (for instance, `Vector`, `Point`, and `TimeSpan`) but uses static methods. I think it kills the flow of the code. Compare static instantiation and arithmetic

```csharp
var distance = Velocity.PerSecond(Distance.FromMicrons(100)).DistanceAfter(TimeSpan.FromSeconds(10));
```

to extension methods and operator overloads

```csharp
var distance = 100.MicronsPerSecond() * 10.Seconds();
```

Anyone could understand the units in play and the math happening here. The flow of the extension methods and operator overloads is worth more than the weak claim of static method name clarity.

## A Hard Problem in Primitives

The unit types are neat (`Distance`, `Velocity`, and `Acceleration`), but they solve a straight-forward problem. Let's look at a more complicated use.

We direct a linear motor to move a sample under a camera. The motor produces electronic "ticks" as it moves. A logic board coordinates the ticks and the frame capture. But, the board associates a frame to *relative* ticks. For example, a picture is taken every `X` ticks after an initial `Y` ticks (time to accelerate to full velocity). The results from the board need to be offset `Y` ticks + (`X` ticks * `N` frames).

```csharp
public class CameraResult
{
    public int Ticks { get; }
    public int FocusScore { get; }
    public Byte[] Buffer { get; }
}
```

And let's throw another glitch in while we're at it... this particular board uses a `ushort` instead of an `int`, internally. The returned ticks *often* overflow (the ticks between "this" result and the reference value is greater than `ushort.MaxValue`). Using just primitives, the method to convert a result from the board to a distance to move the motor was uninformative and confusing. 

```csharp
public double ConvertTo(double initial, int ticks)
{
    if(_isFirst)
    {
        _reference = ticks;
        _isFirst = false;
        return initial;
    }

    ticks = AdjustUshortOverflow(_reference, ticks);
    var distance = ((_reference - ticks) / 100.0) + initial;
    _reference = ticks;
    return distance;
}
```

There's no information here! I don't know that the ticks parameter is really a (potentially) overflowed `ushort` stuffed into an `int`. The scale in line 11 (`100.0`) doesn't reveal the distance per ticks. Let's try again with a new unit type. `EncoderValue` is the basic type to express the "ticks" from the motor.

```csharp
public class EncoderValue
{
    public int Ticks { get; private set; }
    
    public EncoderValue(int ticks)
    {
        Ticks = ticks;
    }

    public override string ToString()
    {
        return string.Format("{0} encoder ticks", Ticks);
    }
}
```

`RelativeEncoderValue` is almost the same, but it has a specific name! It represents the (potentially) overflowed `ushort` jammed into an `int` that the board returns. And it can't be converted directly into `EncoderValue` (which is good for enforcing the fix).

```csharp
public class RelativeEncoderValue
{
    public int Ticks { get; private set; }

    public RelativeEncoderValue(int ticks)
    {
        Ticks = ticks;
    }

    public override string ToString()
    {
        return string.Format("{0} relative encoder ticks", Ticks);
    }
}
```

The glue is `FixedRelativeEncoderValue`. This expresses the value from the board un-overflowed and *fixed* with the data from the reference point. The only way to get here is to use the `Fix` method.

```csharp
public class FixedRelativeEncoderValue
{
    private const ushort OverflowThreshold = ushort.MaxValue / 2;

    public static FixedRelativeEncoderValue Fix(FixedRelativeEncoderValue reference, RelativeEncoderValue target)
    {
        if (Math.Abs(reference - target) <= OverflowThreshold)
            return new FixedRelativeEncoderValue(target.Ticks) { DifferenceFromReference = new EncoderValue(reference.Ticks - target.Ticks) };

        var value = reference < OverflowThreshold
            ? target - ushort.MaxValue
            : target + ushort.MaxValue;

        return new FixedRelativeEncoderValue(value.Ticks) { DifferenceFromReference = new EncoderValue(reference.Ticks - value) };
    }

    public int Ticks { get; private set; }
    public EncoderValue DifferenceFromReference { get; private set; }

    public FixedRelativeEncoderValue(int ticks)
    {
        Ticks = ticks;
    }

    public FixedRelativeEncoderValue Fix(RelativeEncoderValue target)
    {
        return Fix(this, target);
    }

    public override string ToString()
    {
        return string.Format("{0} encoder ticks (delta: {1})", Ticks, DifferenceFromReference);
    }
}
```

`EncoderScale` allows us to express ticks per micron in a scale insensitive manner and to perform math, like `EncoderScale * EncoderValue = Distance`.

```csharp
public class EncoderScale
{
    // arithmetic operators

    public double TotalTicksPerMicron { get; private set; }
    public double TotalTicksPerMillimeter { get; private set; }

    public EncoderScale(EncoderValue value, Distance distance)
    {
        TotalTicksPerMicron = value.Ticks / distance.TotalMicrons;
        TotalTicksPerMillimeter = value.Ticks / distance.TotalMillimeters;
    }

    public override string ToString()
    {
        return string.Format("{0} encoder ticks/um", TotalTicksPerMicron);
    }
}
```

Whew! Now we're ready to make our system a lot richer and to express the nouns we've been using in code (as well as the correct behavior). First, let's revisit the camera result

```csharp
public class CameraResult
{
    public RelativeEncoderValue Ticks { get; }
    public int FocusScore { get; }
    public Byte[] Buffer { get; }
}
```

And the relative ticks to absolute distance conversion becomes not less complicated, but more meaningful at each step.

```csharp
private static readonly EncoderScale CameraResultScale = 100.TicksPerMicron();

public Distance ConvertTo(Distance initial, RelativeEncoderValue target)
{
    if (_isFirst)
    {
        _reference = new FixedRelativeEncoderValue(target.Ticks);
        _isFirst = false;
        return initial;
    }

    var fixedTarget = _reference.Fix(target); 
    _distance += fixedTarget.Difference / CameraResultScale; 
    _reference = fixedTarget;
    return _distance;
}
```


 [ob]: http://grabbagoft.blogspot.com/2007/12/dealing-with-primitive-obsession.html
 [math]: http://msdn.microsoft.com/en-us/library/system.math.aspx
 [uom]: http://blogs.msdn.com/b/andrewkennedy/archive/2008/08/29/units-of-measure-in-f-part-one-introducing-units.aspx
