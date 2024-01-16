//
//  ArchimedeanSpiralText.swift
//  Rings
//
//  Created by Chen Hai Teng on 3/5/21.
//

import SwiftUI
import ArchimedeanSpiral
import CoreGraphicsExtension
import Common

// deprecated
public enum TextDirection {
    case Top, Bottom, Left, Right
    var cgangle: CGAngle {
        switch self {
        case .Top:
            return CGAngle.degrees(270.0)
        case .Bottom:
            return CGAngle.degrees(90.0)
        case .Left:
            return CGAngle.degrees(0.0)
        case .Right:
            return CGAngle.degrees(180.0)
        }
    }
}

extension TextDirection {
    var ringLayoutDirection : RingLayoutDirection {
        switch self {
        case .Top:
            RingLayoutDirection.toCenter
        case .Bottom:
            RingLayoutDirection.fromCenter
        case .Left:
            RingLayoutDirection.alongCounterClockwise
        case .Right:
            RingLayoutDirection.alongClockwise
        }
    }
}

public struct ArchimedeanSpiralText: View, CompatibleForeground {
    public typealias Content = Self
    
    private var radiusSpacing: Double
    private var innerRadius: Double
    private var gap: Double
    private var textDirection: RingLayoutDirection = .fromCenter
    private var font = Font.system(size: 20.0)
    public var color: Color
    public var style: any ShapeStyle
    
    private var text: String {
        didSet {
            chars = Array(text.enumerated())
        }
    }
    
    private var chars: [(offset: Int, element:Character)] {
        didSet {
            
        }
    }
    
    private var textPoints: [CGPolarPoint] = []
    
    public init(_ innerRadius: Double = 12.0, radiusSpacing: Double = 10.0, gap: Double = 5.0, text: String = "") {
        self.radiusSpacing = radiusSpacing
        self.innerRadius = innerRadius
        self.gap = gap
        self.text = text
        self.chars = Array(text.enumerated())
        self.color = .white
        self.style = .white
        updateTextPoints()
    }
    
    private mutating func updateTextPoints() {
        let spiral = ArchimedeanSpiral(innerRadius: self.innerRadius, radiusSpacing: self.radiusSpacing, spacing: self.gap)
        textPoints = spiral.equidistantPoints(start: CGAngle.zero, num: self.chars.count)
    }
    
    public var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(chars, id: \.self.offset) { (offset, element) in
                    let pt = self.textPoints[offset].cgpoint
                    let textPt = CGPoint(x: pt.x, y: pt.y)
                    let rotation = textDirection.cgangle(with: self.textPoints[offset].cgangle).toAngle()
                    Text(String(element))
                        .compatibleForeground(self)
                        .rotationEffect(rotation)
                        .offset(x: textPt.x, y: textPt.y)
                        .font(font)
                }
            }.frame(width: geo.size.width, height: geo.size.height, alignment: .center)
        }
    }
}

extension ArchimedeanSpiralText: Adjustable {
    public func radiusSpacing<T: BinaryFloatingPoint>(_ space: T) -> Self {
        setProperty { tmp in
            tmp.radiusSpacing = Double(space)
            tmp.updateTextPoints()
        }
    }
    
    public func innerRadius<T: BinaryFloatingPoint>(_ radius: T) -> Self {
        setProperty { tmp in
            tmp.innerRadius = Double(radius)
            tmp.updateTextPoints()
        }
    }
    
    public func gap<T: BinaryFloatingPoint>(_ gap: T) -> Self {
        setProperty { tmp in
            tmp.gap = Double(gap)
            tmp.updateTextPoints()
        }
    }
    
    public func textDirection(_ direction: TextDirection) -> Self {
        setProperty { tmp in
            tmp.textDirection = direction.ringLayoutDirection
        }
    }
    
    public func textLayoutDirection(_ direction: RingLayoutDirection) -> Self {
        setProperty { tmp in
            tmp.textDirection = direction
        }
    }
    
    public func font(_ font: Font) -> Self {
        setProperty { tmp in
            tmp.font = font
        }
    }
    
    public func textColor(_ color: Color) -> Self {
        setProperty { tmp in
            tmp.color = color
            tmp.style = color
        }
    }
}

struct SegmentedPicker: ViewModifier {
    func body(content: Content) -> some View {
        #if os(watchOS)
        content
        #else
        content.pickerStyle(SegmentedPickerStyle()).padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 7))
        #endif
    }
}

struct ColoredPicker: ViewModifier {
    @Binding var selection: Color
    func body(content: Content) -> some View {
        #if os(macOS) || os(iOS)
        if #available(macOS 11.0, iOS 14.0, macCatalyst 14.0, *) {
            ColorPicker("", selection: _selection)
        } else {
            content.modifier(SegmentedPicker())
        }
        #else
        content.modifier(SegmentedPicker())
        #endif
    }
}

extension Picker {
    func segmented() -> some View {
        modifier(SegmentedPicker())
    }
    
    func colorPicker(_ selection: Binding<Color>) -> some View {
        modifier(ColoredPicker(selection: selection))
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
