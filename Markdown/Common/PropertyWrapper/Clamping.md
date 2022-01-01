## Clamping

### Purpose:
1. For values that have upper and lower bound, provide a way to not write duplicate code.
2. In swift, when one try to preprocess an property before apply it, it needs following code:
```swift
    private var _computedVarStorage: Int
    public var computedVar: Int {
        get {
            return _computedVarStorage
        }
        set {
            _computedVarStorage = newValue*10
        }
    }
```
Because the get/set syntax will change variable to computed variable, it always need write a getter, even through we want a write-only property.

Also, to keep the modified value, a extra storage variable is needed, and it looks ugly.

3. In additionally, we also want the solution could be apply to protocol.

### Solution:
1. Use @propertyWrapper to apply clamp; replace max, min and degree into one declaration.
```swift
    @Clamping(max: 0.0, min: 360.0) var degree = 0.0
    @Clamping(0.0...1.0) var value = 0.5
```
2. In some situation, it need modify the range later, property wrapper use projectedValue to implement this requirement:
```swift
    @Clamping(0.0...1.0) var value = 0.5
    $value = 0.0...10.0
```
3. Although @propertyWrapper is useful, it hard to apply this mechanism to protocol. However, there has a workaround:
```swift
protocol ClampProtocol {
    var degree: Double // Can declare as @Clamping
    var range: ClosedRange<Double> // Can map to projectedValue in @Clamping
}

struct ClampStruct {
    @Clamping(0.0...360.0) var degree = 0.0
    var range: ClosedRange<Double> {
        get { $degree }
        set { $degree = newValue }
    }
}
```
 With this workaround, all class/struct implement ClampProtocol can apply @Clamping to simplify the effort to write clamp function, and keep it interface clear.

The detail about the implementation of @Clamping could be refer to :  [Clamping.swift](Clamping.swift)

### References:

[Property Wrapper - Swift Doc](https://docs.swift.org/swift-book/LanguageGuide/Properties.html#ID617)

[Property Wrapper(SE-0258) - Swift Evolution](https://github.com/apple/swift-evolution/blob/master/proposals/0258-property-wrappers.md)

[Swift: Why does a variable with a setter must also have a getter? - stackoverflow](https://stackoverflow.com/a/34677538/505763)

[PropertyWrappers and protocol declaration? - stackoverflow](https://stackoverflow.com/a/57657870/505763)
