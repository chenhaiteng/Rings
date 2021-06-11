//
//  KnobLayer.swift
//  
//
//  Created by Chen-Hai Teng on 2021/5/22.
//

import SwiftUI

@propertyWrapper
public struct Clamping<T> where T:Comparable {
    private(set) var value: T
    var range: ClosedRange<T>
    public var wrappedValue: T {
        get {
            return value
        }
        set {
            value = clamp(newValue)
        }
    }
    
    public var projectedValue: ClosedRange<T> {
        get { range }
        set {
            range = newValue
            value = clamp(value)
        }
      }
    
    private func clamp(_ v: T) -> T {
        max(min(v, range.upperBound), range.lowerBound)
    }
    
    init(wrappedValue: T, _ range: ClosedRange<T>) {
        self.range = range
        value = wrappedValue // 1st phase, initialize properties.
        value = clamp(wrappedValue) // 2nd phase, custom the value of property
    }
    
    init(wrappedValue: T, max: T, min: T) {
        self.range = min...max
        value = wrappedValue
        value = clamp(wrappedValue)
    }
}

public protocol KnobLayer {
    var isFixed: Bool { get set }
    /// It's a workground to define property wrapper to protocol
    ///
    /// For layers that need the degree to be clamped, it could declare degree with @Clamping as following:
    ///
    /// ```
    /// struct SimpleClampDegreeLayer: KnobLayer {
    ///     // Declare degree in the range 90.0...270.0 with default value 120.0
    ///     @Clamping(90.0...270.0) public var degree = 120.0
    ///     // If the degree range should not be modified from outside, simply declare it with any initial value.
    ///     var degreeRange = 0.0...0.0
    ///     // Other properties...
    /// }
    /// ```
    ///
    /// In additional, if the layer need adjust the range of degree, it can decalare degree with  property wrapper as following:
    /// ```
    /// struct DynamicClampRangeLayer: KnobLayer {
    ///     @Clamping(0.0...360.0) public var degree = 180.0
    ///
    ///     // Re-direct degreeRange to $degree that developer can modify $degree by degreeRange
    ///     var degreeRange: ClosedRange<Double> {
    ///         get { $degree }
    ///         set { $degree = newValue }
    ///     }
    /// }
    /// ```
    /// In most situation, developer also can access $degree without degreeRange:
    /// ```
    /// var dynamicRangeLayer = DynamicClampRangeLayer()
    /// dynamicRangeLayer.$degree = 0.0...100.0
    /// dynamicRangeLayer.degreeRange = 0.0...100.0 // This statement is equal to previous one.
    /// ```
    ///  KnobLayer requires degreeRange for AnyKnobLayer, since it cannot access $degree from KnobLayer protocol directly.
    ///
    var degreeRange: ClosedRange<Double> { get set }
    var degree: Double { get set }
    var view: AnyView { get }
}

/// Type eraser for KnobLayer
public struct AnyKnobLayer: KnobLayer {
    var rawLayer: KnobLayer
    public var isFixed: Bool {
        get {
            return rawLayer.isFixed
        }
        set {
            rawLayer.isFixed = newValue
        }
    }
    
    public var degreeRange: ClosedRange<Double> {
        get {
            return rawLayer.degreeRange
        }
        set {
            rawLayer.degreeRange = newValue
        }
    }
    
    public var degree: Double {
        get {
            return rawLayer.degree
        }
        set {
            rawLayer.degree = newValue
        }
    }
    
    public var view: AnyView {
        get {
            rawLayer.view
        }
    }
    
    public init<T>(_ knobLayer: T) where T: KnobLayer {
        self.rawLayer = knobLayer
    }
}

extension ClosedRange where Bound:BinaryFloatingPoint {
    func toDoubleRange() -> ClosedRange<Double> {
        Double(lowerBound)...Double(upperBound)
    }
}

extension KnobLayer {
    func setBaseProperty(_ setBlock: (_ text: inout Self) -> Void) -> Self {
        let result = _setProperty(content: self) { (tmp :inout Self) in
            setBlock(&tmp)
            return tmp
        }
        return result
    }
    
    public func degree<F>(_ degree: F) -> Self where F: BinaryFloatingPoint {
        setBaseProperty { tmp in
            tmp.degree = Double(degree)
        }
    }
    
    public func degreeRange<F>(_ range: ClosedRange<F>) -> Self where F: BinaryFloatingPoint {
        setBaseProperty { tmp in
            tmp.degreeRange = range.toDoubleRange()
        }
    }
}
