//
//  ImageKnobLayer.swift
//  
//
//  Created by Chen-Hai Teng on 2021/5/22.
//

import SwiftUI

struct ImageKnobLayer : KnobLayer {
    var image: Image
    var isFixed: Bool
    
    var minDegree: Double = 0.0
    var maxDegree: Double = 0.0
    var degree: CGFloat
    
    var view: AnyView {
        get {
            AnyView(image.rotationEffect(Angle.degrees(Double(degree))))
        }
    }
}