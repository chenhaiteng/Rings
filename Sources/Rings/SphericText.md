## SphericText

![Spheric Text Demo](https://user-images.githubusercontent.com/1284944/118671827-60f8fe00-b82a-11eb-9f0f-821841867cba.gif)

### Usage

```swift
// Create SphericText with String
SphericText("123456")

// Create SphericText with word list
SphericText(words: ["123", "456", "789"])

// Create SphericText and bind it with variable
@State var degrees: CGFloat
SphericText("123456", $degrees)

// Adjust SphericText appearance
SphericText("123456")
    .wordSpacing(wordSpacing)           // modify space between words
    .font(.system(size: 32.0))          // adjust font family and size
    .wordColor(textColor)               // change text color
    .wordBackground(backgroundColor)    // change text background color
    .blurMinors(blurMinors)             // bluring words which are not front most
    .rangeOfOpposite(in: 145...210)     // specify the opposite range of the most front word
    .hideOpposite(true)                 // hide words located in opposite range
    .perspective(perspective)           // adjust viewing point
    .radius(radius)                     // adjust the radius of spheric
```
