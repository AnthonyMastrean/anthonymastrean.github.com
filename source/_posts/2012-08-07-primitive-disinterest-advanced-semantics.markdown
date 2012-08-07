---
layout: post
title: "Primitive Disinterest: Advanced Semantics"
date: 2012-08-07 01:11
comments: true
categories: primitive-obsession domain-driven-design
---

The unit types I introduced [last post](/blog/primitive-disinterest) are neat (`Distance`, `Velocity`, and `Acceleration`), but they solve a well known problem. We use them to direct a linear motor. The motor produces electronic "ticks" at a known rate as it moves. A camera is listening to the ticks to coordinate when it takes pictures. But we have a complication! The camera associates its data with *relative* ticks. For example, a picture is taken every `X` ticks after an initial `Y` ticks (time for the stage to accelerate to full velocity). The results from the camera need to be offset `Y` ticks + (`X` ticks * `N` iterations).

```
public class CameraResult
{
    public int Ticks { get; }
    public int FocusScore { get; }
    public Byte[] Buffer { get; }
}
```

And let's throw another glitch in while we're at it... this particular camera uses a `ushort` instead of an `int`, internally. The returned ticks *often* overflow (the ticks between "this" result and the reference value is greater than `ushort.MaxValue`). Using just primitives, the method to convert a result from the camera to a distance to move the motor was uninformative and confusing. 

```
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

There's no information here! I don't know that the ticks parameter is really a (potentially) overflowed `ushort` stuffed into an `int`. The scale in line 11 (`100.0`) doesn't reveal how much distance per ticks. Let's try again with a new unit type. `EncoderValue` is the basic type to express the "ticks" from the motor.

```
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

`RelativeEncoderValue` is almost the same, but it has a specific name! It represents the (potentially) overflowed `ushort` jammed into an `int` that the camera returns. And it can't be converted directly into `EncoderValue` (which is good for enforcing the fix).

```
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

The glue is `FixedRelativeEncoderValue`. This expresses the value from the camera un-overflowed and *fixed* with the data from the reference point. The only way to get here is to use the `Fix` method.

```
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

`EncoderScale` allows us to express ticks per micron (or millimeter) in a scale insensitive manner and to perform math, like `EncoderScale * EncoderValue = Distance`.

```
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

```
public class CameraResult
{
    public RelativeEncoderValue Ticks { get; }
    public int FocusScore { get; }
    public Byte[] Buffer { get; }
}
```

And the relative ticks to absolute distance conversion becomes not less complicated, but more meaningful at each step.

```
public Distance ConvertTo(Distance initial, RelativeEncoderValue target)
{
    if (_isFirst)
    {
        _reference = new FixedRelativeEncoderValue(target.Ticks);
        _isFirst = false;
        return initial;
    }

    var fixedTarget = _reference.Fix(target); 
    _distance += fixedTarget.Difference / 100.TicksPerMicron(); 
    _reference = fixedTarget;
    return _distance;
}
```
