//
//  ArchimedeanSpiralText.swift
//  Rings
//
//  Created by Chen Hai Teng on 3/5/21.
//

import SwiftUI
import ArchimedeanSpiral
import CoreGraphicsExtension

public struct ArchimedeanSpiralText: View {
    private var radiusSpacing: Double
    private var innerRadius: Double
    private var gap: Double
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
    
    public init(_ innerRadius: Double = 12.0, spacing: Double = 10.0, gap: Double = 5.0, text: String = "") {
        self.radiusSpacing = spacing
        self.innerRadius = innerRadius
        self.gap = gap
        self.text = text
        self.chars = Array(text.enumerated())
        updateTextPoints()
    }
    
    private mutating func updateTextPoints() {
        let spiral = ArchimedeanSpiral(innerRadius: self.innerRadius, radiusSpacing: self.radiusSpacing, spacing: self.gap)
        textPoints = spiral.equidistantPoints(start: CGAngle.radians(CGFloat.pi*0.5), num: self.chars.count)
    }
    
    public var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(chars, id: \.self.offset) { (offset, element) in
                    let pt = self.textPoints[offset].cgpoint
                    let textPt = CGPoint(x: pt.x, y: pt.y)
                    Text(String(element))
                        .rotationEffect(self.textPoints[offset].cgangle.toAngle())
                        .offset(x: textPt.x, y: textPt.y)
                        .font(.system(size: 13))
                    
                }
            }.frame(width: geo.size.width, height: geo.size.height, alignment: .center)
        }
    }
}

extension ArchimedeanSpiralText: Adjustable {
    public func spacing<T: BinaryFloatingPoint>(_ space: T) -> Self {
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
    
    public func text(_ text: String) -> Self {
        setProperty { tmp in
            tmp.text = text
            tmp.chars = Array(text.enumerated())
            tmp.updateTextPoints()
        }
    }
}

struct ArchimedeanSpiralTextDemo : View {
    private let demoText = "1234567890abcdefgABCDEFG♩♪♫♬"
    @State var radiusSpacing: Double = 10.0
    @State var innerR: Double = 5.0
    @State var gap: Double = 25.0
    @State var textLength: Double = 10.0
    var body: some View {
        VStack {
            let enabled = String(demoText.prefix(Int(textLength)))
            let disabled = String(demoText.suffix(demoText.count - Int(textLength)))
            ArchimedeanSpiralText()
                .gap(gap)
                .innerRadius(innerR)
                .spacing(radiusSpacing)
                .text(enabled)
            Slider(value: $textLength, in: 1.0...28.0, step: 1.0) {
                Text(enabled).foregroundColor(.white) + Text(disabled).foregroundColor(.gray)
            }.padding(EdgeInsets(top: 0.0, leading: 10.0, bottom: 0.0, trailing: 10.0))
            
            Slider(value: $innerR, in: 0.0...30.0) {
                Text("Inner Radius: \(innerR)")
            }.padding(EdgeInsets(top: 0.0, leading: 10.0, bottom: 0.0, trailing: 10.0))
            Slider(value: $radiusSpacing, in: 10.0...80.0) {
                Text("Radius Spacing: \(radiusSpacing)")
            }.padding(EdgeInsets(top: 0.0, leading: 10.0, bottom: 0.0, trailing: 10.0))
            Slider(value: $gap, in: 10.0...40.0) {
                Text("Gap:\(gap)")
            }.padding(EdgeInsets(top: 0.0, leading: 10.0, bottom: 0.0, trailing: 10.0))
        }
    }
}

struct ArchimedeanSpiralText_Previews: PreviewProvider {
    static var previews: some View {
        ArchimedeanSpiralTextDemo()
    }
}
