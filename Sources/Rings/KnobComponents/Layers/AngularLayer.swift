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

    @ViewBuilder var body: Self.Body { get }
}

extension AngularLayer {
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
    
    public func mappingValue<F>(_ value: F, with mapping:KnobMapping) -> Self where F:BinaryFloatingPoint {
        setBaseProperty { tmp in
            tmp.degreeRange = mapping.degreeRange
            tmp.degree = mapping.degree(from: Double(value))
        }
    }
}

extension ClosedRange where Bound:BinaryFloatingPoint {
    func toDoubleRange() -> ClosedRange<Double> {
        Double(lowerBound)...Double(upperBound)
    }
}

@resultBuilder struct AngularLayerBuilder {
    
    static func buildBlock() -> EmptyView {
        EmptyView()
    }
    
    static func buildFinalResult(_ component: EmptyView) -> EmptyView {
        return component
    }
    
    static func buildBlock<L: AngularLayer>(_ layer:L) -> L.Body {
        layer.body
    }
    
    static func buildFinalResult<V: View>(_ component: V) -> V {
        return component
    }
}

extension AngularLayerBuilder {
    
    static func buildFinalResult<L0: AngularLayer, L1: AngularLayer>(_ component: (L0, L1)) -> ZStack<TupleView<(L0.Body, L1.Body)>> {
        return ZStack {
            component.0.body
            component.1.body
        }
    }
    
    static func buildBlock<L0: AngularLayer, L1: AngularLayer>(_ layer0: L0, _ layer1: L1) -> (L0, L1) {
        return (layer0, layer1)
    }
    
    static func buildFinalResult<L0: AngularLayer, L1: AngularLayer, L2: AngularLayer>(_ component: (L0, L1, L2)) -> ZStack<TupleView<(L0.Body, L1.Body, L2.Body)>> {
        return ZStack {
            component.0.body
            component.1.body
            component.2.body
        }
    }
    
    static func buildBlock<L0: AngularLayer, L1: AngularLayer, L2: AngularLayer>(_ layer0: L0, _ layer1: L1, _ layer2: L2) -> (L0, L1, L2) {
        return (layer0, layer1, layer2)
    }
    
    static func buildFinalResult<L0: AngularLayer, L1: AngularLayer, L2: AngularLayer, L3: AngularLayer>(_ component: (L0,L1,L2,L3)) -> ZStack<TupleView<(L0.Body, L1.Body, L2.Body, L3.Body)>> {
        return ZStack {
            component.0.body
            component.1.body
            component.2.body
            component.3.body
        }
    }
    
    static func buildBlock<L0: AngularLayer, L1: AngularLayer, L2: AngularLayer, L3: AngularLayer>(_ layer0: L0, _ layer1: L1, _ layer2: L2, _ layer3: L3) -> (L0, L1, L2, L3) {
        return (layer0, layer1, layer2, layer3)
    }
    
    static func buildFinalResult<L0: AngularLayer, L1: AngularLayer, L2: AngularLayer, L3: AngularLayer, L4: AngularLayer>(_ component: (L0,L1,L2,L3,L4)) -> ZStack<TupleView<(L0.Body, L1.Body, L2.Body, L3.Body, L4.Body)>> {
        return ZStack {
            component.0.body
            component.1.body
            component.2.body
            component.3.body
            component.4.body
        }
    }
    
    static func buildBlock<L0: AngularLayer, L1: AngularLayer, L2: AngularLayer, L3: AngularLayer, L4: AngularLayer>(_ layer0: L0, _ layer1: L1, _ layer2: L2, _ layer3: L3, _ layer4: L4) -> (L0, L1, L2, L3, L4) {
        return (layer0, layer1, layer2, layer3, layer4)
    }
}
