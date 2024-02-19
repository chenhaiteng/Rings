//
//  LinearMapping.swift
//  
//
//  Created by Chen-Hai Teng on 2021/5/27.
//

import SwiftUI

public struct LinearMapping : KnobMapping, Adjustable {
    private var minDegree: Double {
        get {
            degreeRange.lowerBound
        }
    }
    private var maxDegree: Double {
        get {
            degreeRange.upperBound
        }
    }
    public var degreeRange: ClosedRange<Double>
    public var valueRange: ClosedRange<Double>
    
    var minValue: Double {
        valueRange.lowerBound
    }
    var maxValue: Double {
        valueRange.upperBound
    }
    
    public func newValue(_ record: KnobGestureRecord) -> Double {
        let deltaDegre = (record.current.angle - record.next.angle).degrees
        let deltaValue = value(delta: deltaDegre)
        var nextValue = record.current.value + deltaValue
        if nextValue > maxValue {
            nextValue = maxValue
        }
        if nextValue < minValue {
            nextValue = minValue
        }
        return nextValue
    }
    
    public func degree(from value: Double) -> Double {
        if(value < minValue) {
            return minDegree
        }
        if(value > maxValue) {
            return maxDegree
        }
        let ratio = (value - minValue)/(maxValue - minValue)
        return ratio * (maxDegree - minDegree) + minDegree
    }
    
    private func value(delta degree: Double) -> Double {
        return degree * (maxValue - minValue) / (maxDegree - minDegree)
    }
    
    public init<T: BinaryFloatingPoint>(degreeRange: ClosedRange<T> = Default.degreeRange,
                valueRange: ClosedRange<T> = Default.valueRange) {
        self.degreeRange = degreeRange.toDoubleRange()
        self.valueRange = valueRange.toDoubleRange()
    }
}

extension LinearMapping {
    public func valueRange<T: BinaryFloatingPoint>(_ range: ClosedRange<T>) -> Self {
        setProperty { tmp in
            tmp.valueRange = range.toDoubleRange()
        }
    }
}
