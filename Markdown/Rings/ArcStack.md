## ArcStack

### Preview:
ArcStack is based on the [Layout](https://developer.apple.com/documentation/swiftui/layout) protocol. It arranges views along the given arc.

![Demo](../../../Sources/Rings/Documentation.docc/Resources/ArcStack.gif)

### Usage:
Create an ArcStack
```swift
ArcStack {
    Image(systemName:"star")
    Text("arc view 1")
    Text("arc view 2")
    // other views...
}
```

Create an ArcStack which is located on top leading corner:
```swift
ArcStack(anchor: .topLeading) {
    // put views
}
```

Layout views in an ArcStack with specified range:
```swift
ArcStack(range: 0...0.5) { // layout views in half of the arc
    // put views
}
```

For other usages, please refer to the preview in source code.
