//
//  KnobMapping.swift
//  
//
//  Created by Chen-Hai Teng on 2021/5/27.
//

import SwiftUI

enum Default {
    enum Degree: Double {
        case Min = -225.0
        case Max = 45.0
    }
    enum Value: Double {
        case Min = 0.0
        case Max = 1.0
    }
}

public struct KnobGestureRecord {
    struct Value {
        var value: Double = .nan
        var angle: Angle
    }
    var start: Value
    var current: Value
    var next: Value
}

public protocol KnobMapping : Adjustable {
    var degreeRange: ClosedRange<Double> { get set }
    func degree(from value: Double) -> Double
    func newValue(_ record: KnobGestureRecord) -> Double
}

extension KnobMapping {
    func degreeRange(_ range: ClosedRange<Double>) -> Self {
        setProperty { tmp in
            tmp.degreeRange = range
        }
    }
}
