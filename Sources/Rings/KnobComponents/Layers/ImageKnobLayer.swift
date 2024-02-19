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
#if os(macOS)
        Image(nsImage: Bundle.module.image(forResource: "ImageKnobBG")!).resizable()
#else
        Image(systemName: "sparkle")
#endif
    }.radius(100.0).body
}
