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
            true
        }
        set {
            
        }
    }
    
    public var degree: Double {
        get {
            0.0
        }
        set {
            
        }
    }
    public var degreeRange: ClosedRange<Double> {
        get {
            0.0...1.0
        }
        
        set {
        
        }
    }
    
    public var body: Either<Left.Body, Right.Body> {
        bimap(left: \.body, right: \.body)
    }
}


