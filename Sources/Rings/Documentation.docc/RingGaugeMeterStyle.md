# RingGaugeMeterStyle
A collection of gauge styles those can apply to SwiftUI/Gauge to show circular garuges.

## Overview:

Currently, the RingGaugeMeterStyle provides 2 styles:
- ``RingGaugeMeterStyle/CustomStyle``: A custom style which allow developer to composite multiple layers to create their own complex gauge style.
- ``RingGaugeMeterStyle/SemiCircleStyle``: A convenient semi-circular gauge style.

![Demo](RingGaugeMeterStyle)

## Usage:

```swift
// Create a gauge with ``RingGaugeMeterStyle/CustomStyle``
Gauge(value: value, in: 0...50.0, label: {
    Text("Custom Gauge")
}, currentValueLabel: {
    Text("\(value, specifier: "%.2f")")
).gaugeStyle(RingGaugeMeterStyle.CustomStyle(radius: 75.0) {
    GaugeTrackLayer()
    GauageNeedleLayer(center: .center) {
        ZStack {
            GaugeNeedle().frame(width: 8.0, height: 70.0).offset(y: 10.0)
        }
    }
    GaugeValueMarkLayer(10.0) {
        Circle().fill(Color.white)
    }
})

```

```swift
// Create a simple semi-circular gauge with ``RingGaugeMeterStyle/SemiCircleStyle``
Gauge(value: value, in: 0.0...50.0) {

}.gaugeStyle(RingGaugeMeterStyle.SemiCircleStyle(needleView: {
    GaugeNeedle().frame(width: 8.0, height: 60.0)
}))

```

