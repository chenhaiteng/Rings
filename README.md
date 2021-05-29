# Rings ![GitHub](https://img.shields.io/github/license/chenhaiteng/Rings?style=plastic) ![GitHub release (latest by date)](https://img.shields.io/github/v/release/chenhaiteng/Rings)

**Rings** is a collection of controls which have similar shapes of ring, circle...

It includes following controls, click to see what it looks like:

* **[RingText](#ringtext)**
* **[ClockIndex](#clockindex)**
* **[HandAiguille](#handaiguille)**
* **[ArchimedeanSpiralText](#archimedeanspiraltext)**
* **[SphericText](#spherictext)**

and following functions are in progress:

* Knob

---
## Installation:
Rings is published with Swift Package Manager, you can get more information at ![Swift Package Manager(GitHub)](https://github.com/apple/swift-package-manager), ![Package Manager(swift.org)](https://swift.org/package-manager/), and ![Swift Packages(Apple)](https://developer.apple.com/documentation/swift_packages)

### Install Rings Step by Step
#### - Add to Xcode(To use this package in your application):

1. File > Swift Packages > Add Package Dependency...
2. Choose Project you want to add Rings
3. Paste repository https://github.com/chenhaiteng/Rings.git
4. Rules > Version: Up to Next Major 0.1.0
It's can also apply Rules > Branch : main to access latest code.
If you want try some experimental features, you can also apply Rules > Branch : develop

**Note:** It might need to link Rings to your target maunally.
1. Open *Project Editor* by tap on root of project navigator
2. Choose the target you want to use Rings.
3. Choose **Build Phases**, and expand **Link Binary With Libraries**
4. Tap on **+** button, and choose Rings to add it.

#### - Add to SPM package(To use this package in your library/framework):
```swift
dependencies: [
    .package(name: "Rings", url: "https://github.com/chenhaiteng/Rings.git", from: "0.1.0")
    // To specify branch, use following statement to instead of.
    // .package(name: "Rings", url: "https://github.com/chenhaiteng/Rings.git", .branch("branch_name"))
],
targets: [
    .target(
        name: "MyPackage",
        dependencies: ["Rings"]),
]
```
---

## RingText

### What it looks like
![RingDemo](https://user-images.githubusercontent.com/1284944/115984682-fb26a700-a5da-11eb-8a59-a1554ec41bdf.gif)

### ![How to use it](Sources/Rings/RingText.md)

## ClockIndex

### What it looks like
![ClockIndex Demo Classic](https://user-images.githubusercontent.com/1284944/116664495-26d6d200-a9cb-11eb-906c-7ffe659dcfbc.gif)

<img width="598" alt="earchly_clock_demo" src="https://user-images.githubusercontent.com/1284944/116664737-73baa880-a9cb-11eb-97e1-afcb49dfcfcd.png">

### ![How to use it](Sources/Rings/ClockIndex.md)

## HandAiguille

### What it looks like:
![HandAguille](https://user-images.githubusercontent.com/1284944/118101511-47128200-b40a-11eb-870f-90ac2f2a302a.gif)

### ![How to use it](Sources/Rings/HandAiguille.md)

## ArchimedeanSpiralText

### What it looks like:
![ArchimedeanSpiralTextDemo](https://user-images.githubusercontent.com/1284944/117950922-3ef10e80-b346-11eb-9da1-50b0f87990a2.gif)

### ![How to use it](Sources/Rings/ArchimedeanSpiralText.md)

## SphericText

### What it looks like:
![Spheric Text Demo](https://user-images.githubusercontent.com/1284944/118671827-60f8fe00-b82a-11eb-9f0f-821841867cba.gif)

### ![How to use it](Sources/Rings/SphericText.md)

## Knob

### What it looks like:

### ![How to use it](Sources/Rings/Knob.md)

---
# License
Rings is released under the [MIT License](LICENSE).
