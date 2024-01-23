# RingStack

## Overview:
RingStack is based on the [Layout](https://developer.apple.com/documentation/swiftui/layout) protocol. It arranges views along a circle.

![Demo](RingStack.gif)

## Usage:
Following code snippets placing views in a circle which radius depends on its frame:
```swift
RingStack {
    Image(systemName: "star")
    Image(systemName: "moon")
    Image(systmeName: "sun.min")
}
```

To specify those views into a fixed sized circle:
```swift
RingStack(radius: 100.0) {
    Image(systemName: "star")
    Image(systemName: "moon")
    Image(systmeName: "sun.min")
}.frame(width: 300.0, height: 300.0)
```

To layout views with offsets:
```swift
RingStack(center: UnitPoint(x:0.7, y:0.0)) {
    // placing views here
}
```

Apply rotation on whole RingStack:
```swift
RingStack(phase: Angle(degrees: 45.0)) {
    // placing views here
}
```

Also, it can support [ForEach](https://developer.apple.com/documentation/swiftui/foreach) syntax as following:
```swift
@State var numberCount: Int
RingStack {
    ForEach(1..<numberCount, id: \.self)  { num in
        Text("\(num)")
    }
}
```
