//
//  SwiftUIView.swift
//  
//
//  Created by Chen-Hai Teng on 2021/5/22.
//

import SwiftUI

struct RingKnobLayer : KnobLayer {
    var isFixed: Bool = true
    var minDegree: Double = 0.0
    var maxDegree: Double = 0.0
    var degree: CGFloat = 0.0
    
    var view: AnyView {
        get {
            AnyView(Circle().stroke(ringAngularGradient(), lineWidth: ringWidth).padding(EdgeInsets(top: ringWidth/2.0, leading: ringWidth/2.0, bottom: ringWidth/2.0, trailing: ringWidth/2.0)))
        }
    }
    private func ringAngularGradient() -> AngularGradient {
        let gradient = ringGradient ?? Gradient(colors: [ringColor])
        return AngularGradient(gradient: gradient, center: .center, startAngle: Angle.degrees(minDegree), endAngle: Angle.degrees(maxDegree))
    }
    private var ringColor: Color = .white
    private var ringGradient: Gradient? = nil
    private var ringWidth: CGFloat = 2.0
    
    public init() {}
}

extension RingKnobLayer : Adjustable {
    public func ringColor(_ color: Color) -> Self {
        setProperty { tmp in
            tmp.ringColor = color
            tmp.ringGradient = nil
        }
    }
    public func ringColor(_ gradient: Gradient) -> Self {
        setProperty { tmp in
            tmp.ringGradient = gradient
            tmp.ringColor = .clear
        }
    }
    public func ringWidth<T>(_ width: T) -> Self where T:BinaryFloatingPoint {
        setProperty { tmp in
            tmp.ringWidth = CGFloat(width)
        }
    }
}
