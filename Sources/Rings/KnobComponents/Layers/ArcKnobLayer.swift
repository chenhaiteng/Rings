//
//  ArcKnobLayer.swift
//  
//
//  Created by Chen-Hai Teng on 2021/5/22.
//

import SwiftUI
import Common
import GradientBuilder

extension StrokeStyle {
    func width(_ w: CGFloat) -> Self {
        var copy = self
        copy.lineWidth = w
        return copy
    }
}

public struct ArcKnobLayer : AngularLayer {
    public var isFixed: Bool
    
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
    private var gradient: Gradient = Gradient(colors: [.white])
    private var style: StrokeStyle = StrokeStyle()
    
    public var body: some View {
        get {
            ZStack {
                GeometryReader { geo in
                    let radius = min(geo.size.height, geo.size.width)/2.0 - arcWidth/2.0
                    Path { p in
                        p.addArc(center: CGPoint(x: geo.size.width/2, y: geo.size.height/2), radius: radius, startAngle: Angle.degrees(degreeRange.lowerBound), endAngle: isFixed ? Angle.degrees(degreeRange.upperBound) : Angle.degrees(Double(degree)), clockwise: false)
                    }.stroke(AngularGradient(gradient: gradient, center: .center, startAngle: Angle.degrees(degreeRange.lowerBound)), style:style.width(arcWidth))
                }
            }
        }
    }
    
    init(fixed: Bool = false) {
        isFixed = fixed
    }
}

extension ArcKnobLayer : Adjustable {
    public func arcWidth<F>(_ width:F) -> Self where F: BinaryFloatingPoint {
        setProperty { tmp in
            tmp.arcWidth = CGFloat(width)
        }
    }
    
    public func arcColor(@GradientBuilder _ builder:()->Gradient) -> Self {
        setProperty { tmp in
            tmp.gradient = builder()
        }
    }
    
    public func style(_ style: StrokeStyle) -> Self {
        setProperty { tmp in
            tmp.style = style
        }
    }
}
