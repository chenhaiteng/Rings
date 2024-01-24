## ArcKnobLayer

### Preview:

![Demo](../../../Sources/Rings/Documentation.docc/Resources/ArcKnobDemo.gif)

From left to right, those are fixed arc with gradient, non-fixed arc with gradient, and fixed arc with custom style and gradient color.

### Usage:

#### Non-fixed arc:
```swift
ArcKnobLayer().arcWidth(5.0).arcColor {
    (Color.green, 0.6)
    (Color.yellow, 0.7)
    (Color.yellow, 0.9)
    (Color.red, 0.95)
}.degree(degree).body
```
The default arc layer is non-fixed. It draws arc based on the lower bound of *degreeRange*, and its current *degree*.

Note that the 0.0 degree located at positive y-axis.

#### Fixed arc with gradient
```swift
ArcKnobLayer(fixed: true).arcColor {
    (Color.green.opacity(0.3), 0.6)
    (Color.yellow.opacity(0.3), 0.7)
    (Color.yellow.opacity(0.3), 0.9)
    (Color.red.opacity(0.3), 0.95)
}.arcWidth(5.0)
```
When you create a fixed ArcKnobLayer, it draws arc based on its *degreeRange*(default is -225.0...45.0.)

#### Custom color
The *arcColor* supports following DSL:
```swift
// Create balance-distributed gradient with Color list
ArcKnobLayer(fixed: true).arcColor {
    Color.red
    Color.yellow
}

// Create banlance-distributed gradient with rgba or rgbaf tuple
ArcKnobLayer(fixed: true).arcColor {
    (255, 0, 0, 255) // Red
    (1.0, 0.0, 0.0, 0.5) // Red with alpha 0.5
}

// Create custom ratio gradient with Gradient.Stop
ArcKnobLayer(fixed: true).arcColor {
    Gradient.Stop(color: .red, location: 0.2)
    Gradient.Stop(color: .green, location: 0.8)
}

// Create custom ratio grdient with simplified stop tuple
ArcKnobLayer(fixed: true).arcColor {
    (Color.red, 0.2)
    (Color.green, 0.8)
}
```
Also, if it needs single color, just put one color in block.

#### Custom Style
```       
ArcKnobLayer(fixed:true).arcWidth(5.0).arcColor {
    (Color.green, 0.6)
    (Color.yellow, 0.7)
    (Color.yellow, 0.9)
    (Color.red, 0.95)
}.style(StrokeStyle(lineCap: .butt, 
    lineJoin: .miter, 
    miterLimit: 1.0, 
    dash: [5.0,2.0], 
    dashPhase: 1.0))
```
ArcKnobLayer allows developer to provide its own stroke style, but the attribute *lineWidth* will be **ignored**.
To adjust the width of arc layer, use *arcWidth* instead of.
