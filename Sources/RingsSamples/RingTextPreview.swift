//
//  RingTextPreview.swift
//  Rings
//
//  Created by Chen Hai Teng on 10/7/24.
//

import SwiftUI
import Rings

@available(tvOS, unavailable)
struct RingTextPreviewWrapper: View {
    @State var spacing: Double = 0.0
    @State var begin: Double = 0.0
    @State var end: Double = 360.0
    @State var upside_down: Bool = false
    @State var reverse_text: Bool = false
    @State var begin_0: Double = 0.0
    @State var font_size: Double = 20.0
    @State var blueprint: Bool = false
    var body: some View {
        VStack {
            HStack {
                VStack {
                    ZStack {
                        RingText(radius: 40.0, color: .blue, upsideDown: false) {
                            "✪"
                            for i in 1...10 {
                                "\(i)"
                            }
                        }.font(Font.custom("Apple Chancery", size: 16.0)).begining(atDegrees: begin_0).showingBlueprint(blueprint).contentShape(Circle())
                        #if !os(tvOS)
                            .onTapGesture(count: 2, perform: {
                            begin_0 = 0.0
                            font_size = 20.0
                        })
                        #endif
                        RingText(radius: 80.0, text: "0987654321", color: .green).font(.system(size: CGFloat(font_size))).showingBlueprint(blueprint)
                    }
                    Text("begin degrees: \(begin_0)")
                    Slider(value: $begin_0, in: -360.0...360)
                    Text("font size: \(font_size)")
                    Slider(value: $font_size, in: 10.0...40.0, step: 1)
                }
                ZStack {
                    RingText(radius: 40.0) {
                        "a23"
                        "b56"
                        "c89"
                    }.showingBlueprint(blueprint)
                    RingText(radius: 80.0) {
                        "1234567890"
                    }.showingBlueprint(blueprint)
                }
                VStack {
                    ZStack {
                        RingText(radius: 60.0) {
                            if reverse_text {
                                "09876"
                                "54321"
                            } else {
                                "12345"
                                "67890"
                            }
                        }.begining(atDegrees: begin)
                        .ending(atDegrees: end)
                        .upsideDowning(upside_down)
                        .textColor(.red).showingBlueprint(blueprint)
                        RingText(radius: 40.0){
                            if reverse_text {
                                String("1234567890".reversed())
                            } else {
                                "1234567890"
                            }
                        }.kerning(spacing)
                        .upsideDowning(upside_down)
                        .textColor(.blue).showingBlueprint(blueprint)
                    }
                    VStack(alignment: .leading) {
                        Text("char kerning : \(spacing)")
                        Slider(value: $spacing, in: 0.0...30.0)
                        Text("begin degrees: \(begin)")
                        Slider(value: $begin, in: 0.0...360.0)
                        Text("end degrees: \(end)")
                        Slider(value: $end, in: 0.0...360.0)
                        Toggle("Upside Down", isOn: $upside_down)
                        Toggle("Reverse Text", isOn: $reverse_text)
                    }
                }
            }.background(Color.black)
            Toggle("Show Layout", isOn:$blueprint)
        }
    }
}

@available(iOS 14.0, macOS 11.0, tvOS 13.0, watchOS 6.0, *)
#Preview {
#if os(tvOS)
    Text("No Preview Yet")
#else
    RingTextPreviewWrapper()
#endif
}
