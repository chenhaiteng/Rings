##  ClockIndex

![ClockIndex Demo Classic](https://user-images.githubusercontent.com/1284944/116664495-26d6d200-a9cb-11eb-906c-7ffe659dcfbc.gif)

<img width="598" alt="earchly_clock_demo" src="https://user-images.githubusercontent.com/1284944/116664737-73baa880-a9cb-11eb-97e1-afcb49dfcfcd.png">

### Usage:

```Swift
  // Default clock index with radius 50.0
  ClockIndex().radius(50.0)
  
  // Modify hour index style with radius.
  ClockIndex().hourIndexStyle(StrokeStyle(lineWidth: 5.0).hourStyle(with: indexRadius))
   
  // Custom hour marker text
  ClockIndex(textMarkers: ["I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX", "X", "XI", "XII"])
  
  // Show/Hide hour index and minutes track
  ClockIndex().showIndex(shouldShowIndex)
```

