//
//  Either+AngularLayer.swift
//  
//
//  Created by Chen Hai Teng on 8/19/21.
//

import SwiftUI
import SequenceBuilder

extension Either : AngularLayer where Left:AngularLayer, Right: AngularLayer {
    
    public var isFixed: Bool {
        get {
            switch self {
            case .left(let layer):
                return layer.isFixed
            case .right(let layer):
                return layer.isFixed
            }
        }
        mutating set {
            switch self {
            case .left(var layer):
                layer.isFixed = newValue
                self = .left(layer)
            case .right(var layer):
                layer.isFixed = newValue
                self = .right(layer)
            }
        }
    }
    
    public var degree: Double {
        get {
            switch self {
            case .left(let layer):
                return layer.degree
            case .right(let layer):
                return layer.degree
            }
        }
        mutating set {
            switch self {
            case .left(var layer):
                layer.degree = newValue
                self = .left(layer)
            case .right(var layer):
                layer.degree = newValue
                self = .right(layer)
            }
        }
    }
    
    public var degreeRange: ClosedRange<Double> {
        get {
            switch self {
            case .left(let layer):
                return layer.degreeRange
            case .right(let layer):
                return layer.degreeRange
            }
        }
        
        mutating set {
            switch self {
            case .left(var layer):
                layer.degreeRange = newValue
                self = .left(layer)
            case .right(var layer):
                layer.degreeRange = newValue
                self = .right(layer)
            }
        }
    }
    
    public var offset: CGPoint {
        get {
            switch self {
            case .left(let layer):
                return layer.offset
            case .right(let layer):
                return layer.offset
            }
        }
        
        mutating set {
            switch self {
            case .left(var layer):
                layer.offset = newValue
                self = .left(layer)
            case .right(var layer):
                layer.offset = newValue
                self = .right(layer)
            }
        }
    }
    
    public var radius: CGFloat {
        get {
            switch self {
            case .left(let layer):
                return layer.radius
            case .right(let layer):
                return layer.radius
            }
        }
        
        mutating set {
            switch self {
            case .left(var layer):
                layer.radius = newValue
                self = .left(layer)
            case .right(var layer):
                layer.radius = newValue
                self = .right(layer)
            }
        }
    }
    
    public var body: Either<Left.Body, Right.Body> {
        bimap(left: \.body, right: \.body)
    }
}


