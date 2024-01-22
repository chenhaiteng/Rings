#  ArchimedeanSpiralText

## Overview:

![ArchimedeanSpiralTextDemo](https://user-images.githubusercontent.com/1284944/117950922-3ef10e80-b346-11eb-9da1-50b0f87990a2.gif)

## Usage:
```swift
// Create text along archimedean spiral
ArchimedeanSpiralText("My Archimedean Spiral")

// Setup Archimedean Spiral parameters
ArchimedeanSpiralText("My Archimedean Spiral")
  .gap(10.0)                // To setup the distance between two calculated points.
  .innerRadius(15.0)        // To specify the start radius of an archimedean spiral
  .spacing(radiusSpacing)   // To adjust the constant separation distance between intersection points measured from the origin.
   
// Update the text appearance
ArchimedeanSpiralText()
  .text("My Archimedean Spiral")  // Modifing text content
  .textDirection(direction)       // Specifing the direction of text.
  .textColor(color)               // Change text color
  .font(font)                     // Change font and text size
```
