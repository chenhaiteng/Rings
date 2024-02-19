# GaugeMeter
A circular view that shows a value within a range.
Supports mac OS 14.0, iOS 14, tvOS 13, and watchOS 6.

## Overview:

> Important: For iOS 16.0+, iPadOS 16.0+, macOS 13.0+, Mac Catalyst 16.0+, watchOS 7.0+, and visionOS 1.0+, it suggest to use ``RingGaugeMeterStyle/CustomStyle`` and [Guage](https://developer.apple.com/documentation/swiftui/gauge) instead of.

![Demo](GaugeMeterDemo.gif)

## Usage:

```swift
// Create a GaugeMeter with default size and value-degree range
// This gauge meter has a tracker and a needle to point out current value.
@State var value: Double = 0.0
GaugeMeter(value: value) {
    GaugeTrackLayer()
        .arcColor {
            Color.red
        }
    GauageNeedleLayer(center: needleBase) {
        VStack(spacing:0.0) {
            Circle().frame(width: 12.0, height: 12.0)
            Rectangle().frame(width: 2.0, height: 20.0)
        }
    }
}
```

```swift
// A Gauge meter with custom degree and value range.
// Also, applys more complex design on tracker.
@State var value: Double = 0.0
GaugeMeter(value: value, mapping: LinearMapping(degreeRange: -90.0...90.0, valueRange: 0.0...60.0)) {
    // Apply a track with gradient and stroke style.
    GaugeTrackLayer()
        .arcColor {
            Color.green
            Color.yellow
            Color.red
        }.style(StrokeStyle(dash:[3.0, 3.0]))
    // Use a image needle
    GauageNeedleLayer(center: needleBase) {
        Image("CustomGaugeNeedle")
    }
    // Add a value mark to point out current value on the gauge arc.
    GaugeValueMarkLayer {
        Circle()
    }
}
```
