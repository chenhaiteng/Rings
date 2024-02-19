# ClockIndex
A view to show clock index.

## Overview:
> Important: Deprecated at Rings 0.5.0. Use ``ClockIndexShape`` and ``RingStack`` instead of.

![Demo](ClockIndex.gif)

## Usage:

```Swift
  // Default clock index with radius 50.0
  ClockIndex().radius(50.0)
  
  // Modify hour index style with radius.
  ClockIndex().hourIndexStyle(StrokeStyle(lineWidth: 5.0).hourStyle(with: indexRadius))
```

