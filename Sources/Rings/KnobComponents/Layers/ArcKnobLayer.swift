//
//  ArcKnobLayer.swift
//  
//
//  Created by Chen-Hai Teng on 2021/5/22.
//

import SwiftUI

public struct ArcKnobLayer : KnobLayer {
    public var isFixed: Bool = false
    public var minDegree: Double = 0.0
    public var maxDegree: Double = 0.0
    private var _degree: CGFloat = 120.0
    public var degree: CGFloat {
        get {
            return _degree
        }
        set {
            if newValue > CGFloat(maxDegree) {
                _degree = CGFloat(maxDegree)
            } else if newValue < CGFloat(minDegree) {
                _degree = CGFloat(minDegree)
            } else {
                _degree = newValue
            }
        }
    }
    
    public var view: AnyView {
        get {
            AnyView(ZStack {
                GeometryReader { geo in
                    Path { p in
                        let radius = min(geo.size.height, geo.size.width)/2.0 - arcWidth/2.0
                        p.addArc(center: CGPoint(x: geo.size.width/2, y: geo.size.height/2), radius: radius, startAngle: Angle.degrees(minDegree), endAngle: Angle.degrees(Double(degree)), clockwise: false)
                    }.stroke(arcColor, lineWidth: arcWidth).opacity(0.5)
                }
            })
        }
    }
    
    private var arcWidth: CGFloat = 5.0
    private var arcColor: Color = .white
    
    public init() {}
}

extension ArcKnobLayer : Adjustable {
    public func arcWidth<F>(_ width:F) -> Self where F: BinaryFloatingPoint {
        setProperty { tmp in
            tmp.arcWidth = CGFloat(width)
        }
    }
    
    public func arcColor(_ color:Color) -> Self {
        setProperty { tmp in
            tmp.arcColor = color
        }
    }
}
