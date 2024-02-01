//
//  ImageKnobLayer.swift
//  
//
//  Created by Chen-Hai Teng on 2021/5/22.
//

import SwiftUI
import Common

public struct ImageKnobLayer : AngularLayer {
    
    var image: Image
    public var isFixed: Bool = false
    
    public var offset: CGPoint = .zero
    public var radius: CGFloat = 0.0
    
    @Clamping(0.0...0.0) public var degree: Double = 0.0
    public var degreeRange: ClosedRange<Double> {
        get {
            $degree
        }
        set {
            $degree = newValue
        }
    }
    
    public var body: some View {
        get {
            image.resizable().if(!isFixed, content: { content in
                content.rotationEffect(Angle.degrees(Double(degree)))
            })
        }
    }
    
    public init(_ image: Image) {
        self.image = image
    }
}
