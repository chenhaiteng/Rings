## RingText

### Preview:

![Demo](../../../Sources/Rings/Documentation.docc/Resources/RingTextDemo.gif)

### Usage:

The examples below show how to use RingText:

1. To layout single word along a circle with specified radius:
```swift
  // To layout the text "1234567890" along a circle with radius 40.
  RingText(radius: 40.0, text: "1234567890")
```

2. To layout multiple words along a circle:
```swift
  RingText(radius: 40.0) {
    "1"
    "2"
    "3"
    "4"
    "5"
    "6"
  }
```

also, you can use for-loop to make the task eaiser:
```swift
  RingText(radius: 40.0) {
    for i in 1...6 {
        "\(i)"
    }
  }
```

In additional, you can apply different layout based on some state:
```swift
  let words = ["1", "2", "3", "4", "5", "6"]
  @State var reversed: Bool = false
  RingText(radius: 40.0) {
    if reversed {
      for word in words.reversed() {
        String(word)
      }
    } else {
      for word in words {
        word
      }
    }
  }
```

3. To make RingText look richer by setup its attributes:
```swift
  RingText(radius: 40.0, text: "1234567890")
    .font(Font.custom("Apple Chancery", size: 16.0)) // Setup font and size
    .begin(degrees: -90.0) // Modify the begining degrees
    .end(degress: 90.0) // Modify the end degrees.
    .textColor(.red) // Change the color of text, default is white.  
```

4. Debug layout with RingText's blue print:
```
  RingText(radius: 40.0, text: "1234567890").showBlueprint(true)
```

