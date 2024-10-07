//
//  ArchimedeanSpiralPreview.swift
//  Rings
//
//  Created by Chen Hai Teng on 10/6/24.
//

import SwiftUI
import CoreGraphicsExtension
import Rings

@available(tvOS, unavailable)
struct ArchimedeanSpiralPath_Preview : View {
    @State var radiusSpacing: Double = 10.0
    @State var innerR: Double = 5.0
    @State var spacing: Double = 25.0
    @State var count: Double = 100.0
    @State var startAt: Double = 0.0
    var body: some View {
        VStack {
            ArchimedeanSpiralPath(innerR, spacing: radiusSpacing, gap: spacing, count: Int(count)).start(CGAngle.degrees(startAt))
            Divider()
            ScrollView {
                HStack {
                    Text("start at")
                    Slider(value: $startAt, in: 0.0...360.0)
                    Text("\(String(format: "%.2f", startAt))")
                }
                HStack {
                    Text("radius spacing")
                    Slider(value: $radiusSpacing, in: 10.0...50.0)
                    Text("\(String(format: "%.2f", radiusSpacing))")
                }
                HStack {
                    Text("inner radius")
                    Slider(value: $innerR, in: 10.0...50.0)
                    Text("\(String(format: "%.2f", innerR))")
                }
                HStack {
                    Text("points spacing")
                    Slider(value: $spacing, in: 10.0...50.0)
                    Text("\(String(format: "%.2f", spacing))")
                }
                HStack {
                    
                    Text("node count")
                    Slider(value: $count, in: 100.0...200.0, step: 10.0)
                    Text("\(String(format: "%d", Int(count)))")
                }
            }
        }.padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
    }
}

#if os(tvOS)
struct ArchimedeanSpiralPath_Preview_tvOS : View {
    @State var radiusSpacing: Double = 50.0
    @State var innerR: Double = 10.0
    @State var spacing: Double = 30.0
    @State var count: Double = 100.0
    @State var startAt: Double = 0.0
    var body: some View {
        VStack {
            ZStack {
                GeometryReader { geo in
                    ArchimedeanSpiralPath(innerR, spacing: radiusSpacing, gap: spacing, count: Int(count)).start(CGAngle.degrees(startAt))
                }
            }
        }
    }
}

#endif

struct ArchimedeanSpiralPath_Previews: PreviewProvider {
    static var previews: some View {
#if os(tvOS)
        ArchimedeanSpiralPath_Preview_tvOS()
#else
        ArchimedeanSpiralPath_Preview()
#endif
    }
}

#if !os(tvOS)
struct ArchimedeanSpiralText_Preview_macOS : View {
    private let demoText = "1234567890abcdefgABCDEFG♩♪♫♬"
    @State var radiusSpacing: Double = 20.0
    @State var innerR: Double = 25.0
    @State var gap: Double = 25.0
    @State var textLength: Double = 15.0
    @State var direction: RingLayoutDirection = .fromCenter
    @State var color: Color = .red
    @State var font: Font = .system(.body)
    
    public var body: some View {
        VStack {
            let enabled = String(demoText.prefix(Int(textLength)))
            let disabled = String(demoText.suffix(demoText.count - Int(textLength)))
            ArchimedeanSpiralText(text: enabled)
                .gap(gap)
                .innerRadius(innerR)
                .radiusSpacing(radiusSpacing)
                .textLayoutDirection( direction)
                .textColor(color)
                .font(font)
            Slider(value: $textLength, in: 1.0...28.0, step: 1.0) {
                Text(enabled).foregroundColor(.white) + Text(disabled).foregroundColor(.gray)
            }.padding(EdgeInsets(top: 0.0, leading: 10.0, bottom: 0.0, trailing: 10.0))
            HStack {
                VStack {
                    Text("text direction")
                    Picker("", selection: $direction) {
                        Text("to Center").tag(RingLayoutDirection.toCenter)
                        Text("from center").tag(RingLayoutDirection.fromCenter)
                        Text("cw").tag(RingLayoutDirection.alongClockwise)
                        Text("ccw").tag(RingLayoutDirection.alongCounterClockwise)
                    }.segmented()
                    Text("text color")
                    Picker("", selection: $color) {
                        Text("White").tag(Color.white)
                        Text("Red").tag(Color.red)
                        Text("Blue").tag(Color.blue)
                        Text("Green").tag(Color.green)
                    }.colorPicker($color)
                    Picker("Font", selection: $font) {
                        Text(".body").tag(Font.system(.body))
                        Text(".caption").tag(Font.system(.caption))
                        Text("Zapfino(10)").tag(Font.custom("Zapfino", size: 10.0))
                    }.segmented()
                }
                VStack {
                    Slider(value: $innerR, in: 0.0...30.0, step: 5.0) {
                        Text("Inner Radius: \(innerR)")
                    }.padding(EdgeInsets(top: 0.0, leading: 10.0, bottom: 0.0, trailing: 10.0))
                    Slider(value: $radiusSpacing, in: 10.0...80.0, step: 5.0) {
                        Text("Radius Spacing: \(radiusSpacing)")
                    }.padding(EdgeInsets(top: 0.0, leading: 10.0, bottom: 0.0, trailing: 10.0))
                    Slider(value: $gap, in: 10.0...40.0, step: 3.0) {
                        Text("Gap:\(gap)")
                    }.padding(EdgeInsets(top: 0.0, leading: 10.0, bottom: 0.0, trailing: 10.0))
                }
            }
        }
    }
}

struct ArchimedeanSpiralText_Preview_iOS : View {
    private let demoText = "1234567890abcdefgABCDEFG♩♪♫♬"
    @State var radiusSpacing: Double = 20.0
    @State var innerR: Double = 25.0
    @State var gap: Double = 25.0
    @State var textLength: Double = 15.0
    @State var direction: RingLayoutDirection = .toCenter
    @State var color: Color = .red
    @State var font: Font = .system(.body)
    
    public var body: some View {
        VStack {
            let enabled = String(demoText.prefix(Int(textLength)))
            let disabled = String(demoText.suffix(demoText.count - Int(textLength)))
            ArchimedeanSpiralText(text: enabled)
                .gap(gap)
                .innerRadius(innerR)
                .radiusSpacing(radiusSpacing)
                .textLayoutDirection(direction)
                .textColor(color)
                .font(font)
            Divider()
            VStack(alignment: .leading, spacing: 0.0) {
                HStack {
                    Text(enabled).foregroundColor(color) + Text(disabled).foregroundColor(.gray)
                }
                Slider(value: $textLength, in: 1.0...Double(demoText.count), step: 1.0)
            }
            ScrollView {
                VStack(alignment: .leading, spacing: 0.0) {
                    Text("direction forward to center")
                    Picker("", selection: $direction) {
                        Text("to center").tag(RingLayoutDirection.toCenter)
                        Text("from center").tag(RingLayoutDirection.fromCenter)
                        Text("cw").tag(RingLayoutDirection.alongClockwise)
                        Text("ccw").tag(RingLayoutDirection.alongCounterClockwise)
                    }.segmented()
                    Divider().padding()
                    HStack {
                        Text("text color")
                        Picker("", selection: $color) {
                            Text("White").tag(Color.white)
                            Text("Red").tag(Color.red)
                            Text("Blue").tag(Color.blue)
                            Text("Green").tag(Color.green)
                        }.colorPicker($color)
                    }
                    Divider().padding()
                    Text("font")
                    Picker("Font", selection: $font) {
                        Text(".body").tag(Font.system(.body))
                        Text(".caption").tag(Font.system(.caption))
                        Text("Zapfino(10)").tag(Font.custom("Zapfino", size: 10.0))
                    }.segmented()
                    Divider().padding()
                    VStack(alignment: .leading, spacing: 0.0) {
                        Text("Inner Radius: \(innerR)")
                        Slider(value: $innerR, in: 0.0...30.0, step: 5.0)
                        Text("Radius Spacing: \(radiusSpacing)")
                        Slider(value: $radiusSpacing, in: 10.0...80.0, step: 5.0)
                        Text("Gap:\(gap)")
                        Slider(value: $gap, in: 10.0...40.0, step: 3.0)
                    }
                }
            }
        }.padding(EdgeInsets(top: 0.0, leading: 10.0, bottom: 0.0, trailing: 10.0))
    }
}
#endif

@available(tvOS, introduced: 6.0)
struct ArchimedeanSpiralText_Preview_tvOS : View {
    private let demoText = "1234567890abcdefgABCDEFG♩♪♫♬"
    @State var radiusSpacing: Double = 100.0
    @State var innerR: Double = 50.0
    @State var gap: Double = 80.0
    @State var textLength: Double = 30.0
    @State var direction: RingLayoutDirection = .toCenter
    @State var color: Color = .red
    @State var font: Font = .system(.title)
    
    public var body: some View {
        VStack {
            ArchimedeanSpiralText(text: demoText)
                .gap(gap)
                .innerRadius(innerR)
                .radiusSpacing(radiusSpacing)
                .textLayoutDirection(direction)
                .textColor(color)
                .font(font)
        }
    }
}

struct ArchimedeanSpiralText_Previews: PreviewProvider {
    public static var previews: some View {
#if os(tvOS)
        ArchimedeanSpiralText_Preview_tvOS()
#elseif os(macOS)
        ArchimedeanSpiralText_Preview_macOS()
#elseif os(iOS)
        ArchimedeanSpiralText_Preview_iOS()
#elseif os(watchOS)
#endif
    }
}
