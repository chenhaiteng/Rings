//
//  SwiftUIView.swift
//  
//
//  Created by Chen-Hai Teng on 2021/5/22.
//

import SwiftUI
import Common

@resultBuilder
public enum RingGradientBuilder {
    static func buildBlock(_ components: Color...) -> AngularGradient {
        guard !components.isEmpty else {
            return AngularGradient(gradient: Gradient(colors: [.white]), center: .center)
        }
        
        var flatColors = components.flatMap { Array(repeating:$0,count:2) }
        flatColors += [flatColors[0]] // To close angular gradient
        return AngularGradient(gradient: Gradient(colors: flatColors), center: .center)
    }
}

public struct RingKnobLayer : AngularLayer {
    public var isFixed: Bool = true
    
    @Clamping(max:0.0, min:0.0) public var degree: Double = 0.0
    
    public var degreeRange: ClosedRange<Double> = 0.0...0.0
    
    private var gradient: AngularGradient = AngularGradient(gradient: Gradient(colors: [.white]), center: .center)
    var ringWidth: Double = 5.0
    
    public var body: some View {
        get {
            Circle().stroke(gradient, lineWidth: CGFloat(ringWidth)).padding(EdgeInsets(top: CGFloat(ringWidth/2.0), leading: CGFloat(ringWidth/2.0), bottom: CGFloat(ringWidth/2.0), trailing: CGFloat(ringWidth/2.0)))
        }
    }
}

extension RingKnobLayer : Adjustable {
    func color(@RingGradientBuilder _ builder: ()->AngularGradient ) -> Self {
        var tmp = self
        tmp.gradient = builder()
        return tmp
    }
    
    func ringWidth<T>(_ width: T) -> Self where T: BinaryFloatingPoint {
        var tmp = self
        tmp.ringWidth = Double(width)
        return tmp
    }
    
}
