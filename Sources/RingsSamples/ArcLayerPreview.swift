//
//  SwiftUIView.swift
//  Rings
//
//  Created by Chen Hai Teng on 10/4/24.
//

import SwiftUI
import Rings

@available(tvOS, unavailable)
struct ArcLayerDemo: View {
    @State var degree: Double = -75.0
    var body: some View {
        VStack {
            HStack {
                ArcKnobLayer(fixed: true).arcWidth(5.0).arcColor {
                    (Color.green.opacity(0.3), 0.6)
                    (Color.yellow.opacity(0.3), 0.7)
                    (Color.yellow.opacity(0.3), 0.9)
                    (Color.red.opacity(0.3), 0.95)
                }.degree(degree).offset(dx: 0.0, dy: 20.0).radius(80.0).body.mask(Rectangle()).border(.white)
                
                ArcKnobLayer().arcWidth(5.0).arcColor {
                    (Color.green, 0.6)
                    (Color.yellow, 0.7)
                    (Color.yellow, 0.9)
                    (Color.red, 0.95)
                }.degree(degree).radius(80.0).body
                
                ArcKnobLayer(fixed:true).arcWidth(5.0).arcColor {
                    (Color.green, 0.6)
                    (Color.yellow, 0.7)
                    (Color.yellow, 0.9)
                    (Color.red, 0.95)
                }.style(StrokeStyle(lineCap: .butt, lineJoin: .miter, miterLimit: 1.0, dash: [5.0,2.0], dashPhase: 1.0)).arcWidth(30.0).degree(degree).body
            }.padding().border(.white)
            Slider(value: $degree, in: -225.0...45.0, label: {
                Text("Degree")
            }).padding()
        }
    }
}

#Preview {
#if os(tvOS)
    Text("No Preview Yet")
#else
    ArcLayerDemo()
#endif
}

#Preview {
    ImageKnobLayer {
#if os(macOS)
        Image(nsImage: Bundle.module.image(forResource: "ImageKnobBG")!).resizable()
#else
        Image(systemName: "sparkle")
#endif
    }.radius(100.0).body
}


#Preview {
    GaugeTrackLayer().body
}
