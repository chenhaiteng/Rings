//
//  SegmentMapping.swift
//  
//
//  Created by Chen-Hai Teng on 2021/5/27.
//

import SwiftUI

public struct KnobStop {
    var value: Double
    var degree: Double
    init(_ v:Double, _ d: Double) {
        value = v
        degree = d
    }
}

public struct SegmentMapping: KnobMapping, Adjustable {
    public var degreeRange = Default.Degree.Min.rawValue...Default.Degree.Max.rawValue
    private var sortedStops: [KnobStop] = []
    var stops: [KnobStop] {
        get {
            return sortedStops
        }
        set {
            sortedStops = newValue.sorted { $0.degree < $1.degree }
            if let lower = sortedStops.first, let upper = sortedStops.last {
                degreeRange = lower.degree...upper.degree
            }
        }
    }
    
    public func degree(from value: Double) -> Double {
        let s = stops.first { stop in
            stop.value == value
        }
        return s?.degree ?? Double.nan
    }
    
    func findValue(by degree: Double) -> Double {
        if let estIndex = sortedStops.firstIndex(where: {$0.degree > degree }) {
            if(estIndex == 0) { return sortedStops[estIndex].value }
            let estMax = sortedStops[estIndex]
            let estMin = sortedStops[estIndex - 1]
            let mid = estMax.degree + estMin.degree
            if degree*2 > mid  {
                let v = estMax.value
                return v
            } else {
                return estMin.value
            }
        } else {
            return sortedStops.last?.value ?? .nan
        }
    }
    
    public func newValue(_ record: KnobGestureRecord) -> Double {
        let delta = (record.start.angle - record.next.angle).degrees
        if let oldStop = sortedStops.first(where: { $0.value == record.start.value }) {
            let newDegrees = oldStop.degree + delta
            if(record.current.angle.degrees == newDegrees) { return record.current.value }
            // Process new.degrees
            return findValue(by: newDegrees)
        }
        // Cannot find matched degree for v. Find the nearest instead.
        var minDiff = Double.nan
        var index = sortedStops.count
        sortedStops.enumerated().forEach { i, s in
            let d = abs(s.value - record.current.value)
            if(minDiff == .nan || d < minDiff) {
                minDiff = d
                index = i
            }
        }
        if index < sortedStops.count {
            let oldStop = sortedStops[index]
            let newDegrees = oldStop.degree + delta
            return findValue(by: newDegrees)
        }
        return .nan
    }
    
    public func stops(_ at:[KnobStop]) -> Self {
        setProperty { tmp in
            tmp.stops = at
        }
    }
    
    public init() {}
}
