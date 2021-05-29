##  Knob

### Preview

![Knob Demo](https://user-images.githubusercontent.com/1284944/120065810-e2138900-c0a5-11eb-8324-2fe340bb578f.gif)

### Usage

```swift
    // Baisc Knob drawing value along the circumference.
    @State knobValue : Double                       // default range: 0.0...1.0
    Knob($knobValue)                                // Create a Knob with default mapping(LinearMapping)
        .addLayer(ArcKnobLayer()                    // Add ArcKnobLayer to draw circumference.
                    .arcWidth(10.0)
                    .arcColor(.blue.opacity(0.7)))
        .frame(width: 100.0, height: 100.0)
```
<img src="https://user-images.githubusercontent.com/1284944/120065862-1d15bc80-c0a6-11eb-876f-687db7b35d00.gif" alt="drawing" width="200"/>

---

```swift
    // A Knob drawing value along circular track. 
    @State knobValue : Double                       // default range: 0.0...1.0.
    Knob($knobValue)                                // Create a Knob with default mapping(LinearMapping)
        .addLayer(RingKnobLayer()                   // Add RingKnobLayer as the track.
                    .ringWidth(10.0)
                    .ringColor(.red.opacity(0.5)))
        .addLayer(ArcKnobLayer()                    // Add ArcKnobLayer to draw circumference.
                    .arcWidth(10.0)
                    .arcColor(.blue.opacity(0.7)))
        .frame(width: 100.0, height: 100.0)
```
<img src="https://user-images.githubusercontent.com/1284944/120066040-2bb0a380-c0a7-11eb-865e-e4f2220ffead.gif" alt="drawing" width="200"/>

---

```swift
    // A Knob with rotate image
    @State knobValue : Double                       // default range: 0.0...1.0, the range of knob value depends on mapping object.
    Knob($knobValue)
        .addLayer(ImageKnobLayer(Image("SimpleKnob")))
        .frame(width: 150, height: 150)    
```
<img src="https://user-images.githubusercontent.com/1284944/120066082-61ee2300-c0a7-11eb-97e5-4a64b0bd4e8e.gif" alt="drawing" width="200"/>

And the image sample is following:

<img src="https://user-images.githubusercontent.com/1284944/120066145-ac6f9f80-c0a7-11eb-9a46-20245ca15933.png" alt="drawing" width="200"/>


