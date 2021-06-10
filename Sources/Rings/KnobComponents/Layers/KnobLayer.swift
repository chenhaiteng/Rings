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
            value = max(min(newValue, range.upperBound), range.lowerBound)
        }
    }
    
    public var projectedValue: ClosedRange<T> {
        get { range }
        set { range = newValue }
      }
    
    init(wrappedValue: T, _ range: ClosedRange<T>) {
        self.range = range
        value = max(min(wrappedValue, range.upperBound), range.lowerBound)
    }
}

public protocol KnobLayer {
    var isFixed: Bool { get set }
    var minDegree: Double { get set }
    var maxDegree: Double { get set }
    var degree: CGFloat { get set }
    var view: AnyView { get }
}

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
    
    public var minDegree: Double {
        get {
            rawLayer.minDegree
        }
        set {
            rawLayer.minDegree = newValue
        }
    }
    public var maxDegree: Double {
        get {
            rawLayer.maxDegree
        }
        set {
            rawLayer.maxDegree = newValue
        }
    }
    
    public var degree: CGFloat {
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
            tmp.degree = CGFloat(degree)
        }
    }
    
    public func degreeRange<F>(_ range: ClosedRange<F>) -> Self where F: BinaryFloatingPoint {
        setBaseProperty { tmp in
            tmp.minDegree = Double(range.lowerBound)
            tmp.maxDegree = Double(range.upperBound)
        }
    }
}

