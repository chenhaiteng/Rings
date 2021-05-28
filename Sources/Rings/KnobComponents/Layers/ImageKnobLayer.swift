//
//  ImageKnobLayer.swift
//  
//
//  Created by Chen-Hai Teng on 2021/5/22.
//

import SwiftUI

public struct ImageKnobLayer : KnobLayer {
    var image: Image
    public var isFixed: Bool = false
    
    public var minDegree: Double = 0.0
    public var maxDegree: Double = 0.0
    public var degree: CGFloat = 0.0
    
    public var view: AnyView {
        get {
            AnyView(image.rotationEffect(Angle.degrees(Double(degree))))
        }
    }
    
    public init(_ image: Image) {
        self.image = image
    }
}
