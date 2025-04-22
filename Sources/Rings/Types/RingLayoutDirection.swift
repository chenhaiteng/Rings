//
//  File.swift
//  
//
//  Created by Chen Hai Teng on 1/16/24.
//

import Foundation
import CoreGraphicsExtension
import SwiftUI

public enum RingLayoutDirection : Hashable, Sendable {
    case related(degrees: Double)
    case fixed(degrees: Double)
    
    public static let none = Self.fixed(degrees: 0.0)
    public static let toCenter = Self.related(degrees: 270.0)
    public static let fromCenter = Self.related(degrees: 90.0)
    public static let alongClockwise = Self.related(degrees: 180.0)
    public static let alongCounterClockwise = Self.related(degrees: 0.0)
}

public extension RingLayoutDirection {
    var radians: Double {
        switch self {
        case .fixed(let degrees):
            degrees/180.0*Double.pi
        case .related(let degrees):
            degrees/180.0*Double.pi
        }
    }
    
    var cgangle: CGAngle {
        CGAngle.radians(self.radians)
    }
    
    func cgangle(with angle: Angle) -> CGAngle {
        switch self {
        case .fixed(let degrees):
            CGAngle.degrees(degrees)
        case .related(let degrees):
            CGAngle.degrees(degrees + angle.degrees)
        }
    }
    
    func cgangle(with cgangle: CGAngle) -> CGAngle {
        switch self {
        case .fixed(let fixed):
            CGAngle.degrees(fixed)
        case .related(let related):
            CGAngle.degrees(related + cgangle.degrees)
        }
    }
    
    func cgangle<T: BinaryFloatingPoint>(relatedDegrees: T) -> CGAngle {
        switch self {
        case .fixed(let fixed):
            CGAngle.degrees(fixed)
        case .related(let related):
            CGAngle.degrees(Double(relatedDegrees) + related)
        }
    }
    
    func cgangle<T: BinaryFloatingPoint>(relatedRadians: T) -> CGAngle {
        switch self {
        case .fixed:
            CGAngle(self.radians)
        case .related:
            CGAngle(Double(relatedRadians) + self.radians)
        }
    }
}
