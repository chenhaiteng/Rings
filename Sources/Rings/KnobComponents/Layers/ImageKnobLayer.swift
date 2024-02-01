//
//  ImageKnobLayer.swift
//  
//
//  Created by Chen-Hai Teng on 2021/5/22.
//

import SwiftUI

typealias ImageKnobLayer = CustomViewLayer<Image>

#Preview {
    ImageKnobLayer {
        Image(nsImage: Bundle.module.image(forResource: "ImageKnobBG")!).resizable()
    }.radius(100.0).body
}
