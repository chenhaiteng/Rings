//
//  SwiftUIView.swift
//  
//
//  Created by Chen-Hai Teng on 2021/5/22.
//

import SwiftUI
import Common
import GradientBuilder

public struct RingKnobLayer : AngularLayer {
    public var isFixed: Bool
    
    @Clamping(max:0.0, min:0.0) public var degree: Double = 0.0
    
    public var degreeRange: ClosedRange<Double>
    
    private var gradient: AngularGradient
    var ringWidth: Double
    
    public var body: some View {
        get {
            Circle().stroke(gradient, lineWidth: CGFloat(ringWidth)).padding(EdgeInsets(top: CGFloat(ringWidth/2.0), leading: CGFloat(ringWidth/2.0), bottom: CGFloat(ringWidth/2.0), trailing: CGFloat(ringWidth/2.0)))
        }
    }
    
    public init(isFixed: Bool = true, 
                degree: Double = 0.0,
                degreeRange: ClosedRange<Double> = 0.0...0.0,
                gradient: AngularGradient = AngularGradient(gradient: Gradient(colors: [.white]), center: .center),
                ringWidth: Double = 5.0) {
        self.isFixed = isFixed
        self.degree = degree
        self.degreeRange = degreeRange
        self.gradient = gradient
        self.ringWidth = ringWidth
    }
}

extension RingKnobLayer : Adjustable {
    public func color(@GradientBuilder _ builder: ()->AngularGradient ) -> Self {
        var tmp = self
        tmp.gradient = builder()
        return tmp
    }
    
    public func ringWidth<T>(_ width: T) -> Self where T: BinaryFloatingPoint {
        var tmp = self
        tmp.ringWidth = Double(width)
        return tmp
    }
    
}
