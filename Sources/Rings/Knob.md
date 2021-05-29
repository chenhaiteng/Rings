##  Knob

### Preview

### Usage
```swift
    // Baisc Knob drawing value along the circumference.
    @State knobValue : Double                       // default range: 0.0...1.0, the range of knob value depends on mapping object.
    Knob($knobValue)                                // Create a Knob with default mapping(LinearMapping)
        .addLayer(ArcKnobLayer()                    // Add ArcKnobLayer to draw circumference.
                    .arcWidth(10.0)
                    .arcColor(.blue.opacity(0.7)))
        .frame(width: 100.0, height: 100.0)
```

```swift
    // A Knob drawing value along circular track. 
    @State knobValue : Double                       // default range: 0.0...1.0, the range of knob value depends on mapping object.
    Knob($knobValue)                                // Create a Knob with default mapping(LinearMapping)
        .addLayer(RingKnobLayer()                   // Add RingKnobLayer as the track.
                    .ringWidth(10.0)
                    .ringColor(.red.opacity(0.5)))
        .addLayer(ArcKnobLayer()                    // Add ArcKnobLayer to draw circumference.
                    .arcWidth(10.0)
                    .arcColor(.blue.opacity(0.7)))
        .frame(width: 100.0, height: 100.0)
```

```swift
    // A Knob with rotate image
    @State knobValue : Double                       // default range: 0.0...1.0, the range of knob value depends on mapping object.
    Knob($knobValue)
        .addLayer(ImageKnobLayer(Image("SimpleKnob")))
        .frame(width: 150, height: 150)    
```
