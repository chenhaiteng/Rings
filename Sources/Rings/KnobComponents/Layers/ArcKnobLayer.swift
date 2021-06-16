//
//  ArcKnobLayer.swift
//  
//
//  Created by Chen-Hai Teng on 2021/5/22.
//

import SwiftUI
import Common

public struct ArcKnobLayer : AngularLayer {
    public var isFixed: Bool = false
    
    @Clamping(0.0...0.0) public var degree: Double = 120.0
    public var degreeRange: ClosedRange<Double> {
        get {
            $degree
        }
        set {
            $degree = newValue
        }
    }
    
    
    private var arcWidth: CGFloat = 5.0
    private var arcColor: Color = .white
    
    public var body: some View {
        get {
            ZStack {
                GeometryReader { geo in
                    Path { p in
                        let radius = min(geo.size.height, geo.size.width)/2.0 - arcWidth/2.0
                        p.addArc(center: CGPoint(x: geo.size.width/2, y: geo.size.height/2), radius: radius, startAngle: Angle.degrees(degreeRange.lowerBound), endAngle: Angle.degrees(Double(degree)), clockwise: false)
                    }.stroke(arcColor, lineWidth: arcWidth)
                }
            }
        }
    }
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
