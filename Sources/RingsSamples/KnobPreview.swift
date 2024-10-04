//
//  SwiftUIView.swift
//  Rings
//
//  Created by Chen Hai Teng on 10/4/24.
//

import SwiftUI
import Rings

@available(tvOS, unavailable)
struct KnobDemo: View {
    private static let demoRange: ClosedRange<CGFloat> = -50.0...50.0
    @State var valueSegmented: CGFloat = 0
    @State var valueContiune: CGFloat = demoRange.lowerBound
    @State var ringWidth: CGFloat = 5
    @State var arcWidth: CGFloat = 5
    @State var showBlueprint: Bool = false
    let gradient = AngularGradient(gradient: Gradient(colors: [Color.red, Color.blue]), center: .center)
    var body: some View {
        VStack {
            Spacer(minLength: 40)
            HStack {
                VStack {
                    Knob($valueContiune, LinearMapping().valueRange(KnobDemo.demoRange).degreeRange(-145.0...(-35.0))) {
                        RingKnobLayer()
                            .color {
//                                Color.red
                                Color.blue
//                                Color.yellow
                            }.ringWidth(ringWidth)
                        ArcKnobLayer()
                            .arcColor {
                                .red
                            }.arcWidth(ringWidth)
                        ImageKnobLayer {
#if os(macOS)
                            Image(nsImage: Bundle.module.image(forResource: "ImageKnobBG")!).resizable()
#else
                            Image(systemName: "sparkle")
#endif
                        }
                    }.blueprint(showBlueprint)
                    Slider(value: $valueContiune, in: KnobDemo.demoRange) {
                        Text(String(format: "value: %.2f", valueContiune))
                    }
                }
                VStack {
                    Knob($valueSegmented) {
                        ArcKnobLayer(fixed:true)
                            .arcColor {
                                Color.green.opacity(0.5)
                                Color.yellow.opacity(0.5)
                                Color.red.opacity(0.5)
                            }
                            .arcWidth(arcWidth)
                            .style(StrokeStyle(lineWidth: arcWidth,lineCap: .butt, lineJoin: .bevel, miterLimit: 10.0, dash: [5,2], dashPhase: 10.0))
                        ArcKnobLayer()
                            .arcColor {
                                Color.green
                                Color.yellow
                                Color.red
                            }
                            .arcWidth(arcWidth)
                            .style(StrokeStyle(lineWidth: arcWidth,lineCap: .butt, lineJoin: .bevel, miterLimit: 10.0, dash: [5,2], dashPhase: 10.0))
                        ImageKnobLayer {
#if os(macOS)
                            Image(nsImage: Bundle.module.image(forResource: "ImageKnobBG")!).resizable()
#else
                            Image(systemName: "sparkle")
#endif
                        }
                        
                    }.blueprint(showBlueprint).mapping(with: SegmentMapping().stops([KnobStop(0.0, -225.0), KnobStop(1.0, 45.0), KnobStop(0.5, -90.0), KnobStop(0.2, 0.0), KnobStop(0.8, -180.0), KnobStop(0.3, -135)]))
                    Slider(value: $valueSegmented, in: 0.0...1.0, step: 0.1) {
                        Text(String(format: "value: %.2f", valueSegmented))
                    }
                }
            }
            Spacer(minLength: 40)
            Group {
                Slider(value: $ringWidth, in: 5.0...25.0, step: 1.0) {
                    Text(String(format: "Ring Width: %.2f", ringWidth))
                }
                Slider(value: $arcWidth, in: 5.0...25.0, step: 1.0) {
                    Text(String(format: "Arc Width: %.2f", arcWidth))
                }
                Toggle("blue print", isOn: $showBlueprint)
            }
        }
    }
}

@available(tvOS, unavailable)
struct Knob_Previews: PreviewProvider {
    static var previews: some View {
        KnobDemo()
    }
}
