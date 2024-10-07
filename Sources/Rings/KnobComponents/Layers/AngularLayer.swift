//
//  KnobLayer.swift
//  
//
//  Created by Chen-Hai Teng on 2021/5/22.
//

import SwiftUI

public protocol AngularLayer {
    associatedtype Body : View
    
    var isFixed: Bool { get set }
    /// It's a workground to define property wrapper to protocol
    ///
    /// For layers that need the degree to be clamped, it could declare degree with @Clamping<Double> as following:
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
    var degree: Double { get set }
    var degreeRange: ClosedRange<Double> { get set }

    var body: Self.Body { get }
    var offset: CGPoint { get set }
    var radius: CGFloat { get set }
}

extension AngularLayer {
    func setBaseProperty(_ setBlock: (_ tmp: inout Self) -> Void) -> Self {
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
    
    public func mappingValue<F>(_ value: F, with mapping:KnobMapping) -> Self where F:BinaryFloatingPoint {
        setBaseProperty { tmp in
            tmp.degreeRange = mapping.degreeRange
            tmp.degree = mapping.degree(from: Double(value))
        }
    }
    public func offset<F>(dx: F, dy: F) -> Self where F: BinaryFloatingPoint {
        setBaseProperty { tmp in
            tmp.offset = CGPoint(x: Double(dx), y: Double(dy))
        }
    }
    public func radius<R: BinaryFloatingPoint>(_ newValue: R) -> Self {
        setBaseProperty { tmp in
            tmp.radius = CGFloat(newValue)
        }
    }
}

extension ClosedRange where Bound:BinaryFloatingPoint {
    public func toDoubleRange() -> ClosedRange<Double> {
        Double(lowerBound)...Double(upperBound)
    }
}
