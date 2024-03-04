//
//  SwiftUIView.swift
//  
//
//  Created by Chen-Hai Teng on 2021/5/22.
//

import SwiftUI
import Common
import GradientBuilder
import SwiftClamping

public struct RingKnobLayer : AngularLayer {
    public var isFixed: Bool
    
    @Clamping(max:0.0, min:0.0) public var degree: Double = 0.0
    
    public var degreeRange: ClosedRange<Double>
    
    public var offset: CGPoint = .zero
    public var radius: CGFloat = 100.0
    
    private var gradient: AngularGradient
    var ringWidth: Double
    
    public var body: some View {
        get {
            Circle().stroke(gradient, lineWidth: CGFloat(ringWidth)).frame(width: radius*2.0, height: radius*2.0).padding(EdgeInsets(top: CGFloat(ringWidth/2.0), leading: CGFloat(ringWidth/2.0), bottom: CGFloat(ringWidth/2.0), trailing: CGFloat(ringWidth/2.0)))
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
        setProperty { adjustObject in
            adjustObject.gradient = builder()
        }
    }
    
    public func ringWidth<T>(_ width: T) -> Self where T: BinaryFloatingPoint {
        setProperty { adjustObject in
            adjustObject.ringWidth = Double(width)
        }
    }
    
    public func radius<R: BinaryFloatingPoint>(_ newValue: R) -> Self {
        setProperty { adjustObject in
            adjustObject.radius = CGFloat(newValue)
        }
    }
}
