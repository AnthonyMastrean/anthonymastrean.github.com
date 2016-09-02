---
layout: post
title: "A Primitive Problem"
date: 2011-07-08 00:00
---

Unit types are neat (`Distance`, `Velocity`, and `Acceleration`), but they solve a straight-forward problem. Let's look at a more complicated use.

We direct a linear motor to move a sample under a camera. The motor produces electronic "ticks" as it moves. A logic board coordinates the ticks and the frame capture. But, the board associates a frame to *relative* ticks. For example, a picture is taken every `X` ticks after an initial `Y` ticks (time to accelerate to full velocity). The results from the board need to be offset `Y` ticks + (`X` ticks * `N` frames).

```
public class CameraResult
{
    public int Ticks { get; }
    public int FocusScore { get; }
    public Byte[] Buffer { get; }
}
```

And let's throw another glitch in while we're at it... this particular board uses a `ushort` instead of an `int`, internally. The returned ticks *often* overflow (the ticks between "this" result and the reference value is greater than `ushort.MaxValue`). Using just primitives, the method to convert a result from the board to a distance to move the motor was uninformative and confusing.

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

There's no information here! I don't know that the ticks parameter is really a (potentially) overflowed `ushort` stuffed into an `int`. The scale in line 11 (`100.0`) doesn't reveal the distance per ticks. Let's try again with a new unit type. `EncoderValue` is the basic type to express the "ticks" from the motor.

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

`RelativeEncoderValue` is almost the same, but it has a specific name! It represents the (potentially) overflowed `ushort` jammed into an `int` that the board returns. And it can't be converted directly into `EncoderValue` (which is good for enforcing the fix).

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

The glue is `FixedRelativeEncoderValue`. This expresses the value from the board un-overflowed and *fixed* with the data from the reference point. The only way to get here is to use the `Fix` method.

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

`EncoderScale` allows us to express ticks per micron in a scale insensitive manner and to perform math, like `EncoderScale * EncoderValue = Distance`.

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
