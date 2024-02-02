//
//  SemiCircleGaugeMeter.swift
//
//
//  Created by Chen Hai Teng on 2/2/24.
//

import SwiftUI
import GradientBuilder

@GradientBuilder
func gaugeColors(opacity: Double = 1.0) -> Gradient {
    Color.green.opacity(opacity)
    Color.yellow.opacity(opacity)
    Color.red.opacity(opacity)
}

func trackColor() -> Gradient {
    gaugeColors(opacity: 0.3)
}

func progressColor() -> Gradient {
    gaugeColors()
}

struct SemiCircleGaugeMeter<V: BinaryFloatingPoint, N: View, S: ShapeStyle>: View {
    
    @Binding private var value: V
    private let range: ClosedRange<Double>
    private var needleAnchor: UnitPoint
    private var arcWidth = 10.0
    private var needle: ()->N
    private var valueMarkStyle: S
    private var valueMarkSize: Double = 12.0
    
    var body: some View {
        GeometryReader { geo in
            let r = geo.width/2.0 - arcWidth
            GaugeMeter(radius: r,
                value: $value,
                       mapping: LinearMapping(degreeRange: -180.0...0.0, valueRange: range)) {
                ArcKnobLayer(fixed: true)
                    .arcColor (trackColor).arcWidth(arcWidth).style(StrokeStyle(dash:[3.0, 3.0]))
                ArcKnobLayer()
                    .arcColor(progressColor).arcWidth(arcWidth).style(StrokeStyle(dash:[3.0, 3.0]))
                GauageNeedleLayer(center: needleAnchor) {
                    needle()
                }
                GaugeValueMarkLayer(valueMarkSize) {
                    Circle().fill(valueMarkStyle).shadow(radius: min(valueMarkSize/4.0, 5.0))
                }
            }.frame(width: 2.0*r, height: 2.0*r).offset(x:arcWidth, y: geo.height - r - arcWidth)
        }
    }
    
    init(_ value: Binding<V>, range: ClosedRange<Double> = 0.0...100.0, needleAnchor: UnitPoint = .center, valueMarkStyle: S = Color.clear, @ViewBuilder _ needle: @escaping () -> N = {
        VStack(spacing:0.0) {
            Image(systemName: "triangleshape.fill").resizable().frame(width: 10.0, height: 15.0)
        Rectangle().frame(width: 2.0, height: 50.0)
        }
    }) {
        self._value = value
        self.range = range
        self.needleAnchor = needleAnchor
        self.needle = needle
        self.valueMarkStyle = valueMarkStyle
    }

}

extension SemiCircleGaugeMeter: Adjustable {
    func needleAnchor(_ anchor: UnitPoint) -> Self {
        setProperty { adjustObject in
            adjustObject.needleAnchor = anchor
        }
    }
    func arcWidth<F: BinaryFloatingPoint>(_ value: F) -> Self {
        setProperty { adjustObject in
            adjustObject.arcWidth = Double(value)
        }
    }
    
    func valueMarkSize<F: BinaryFloatingPoint>(_ size: F) -> Self {
        setProperty { adjustObject in
            adjustObject.valueMarkSize = Double(size)
        }
    }
}

fileprivate struct Demo : View {
    struct NeedleShape : Shape {
        func path(in rect: CGRect) -> Path {
            Path { p in
                p.move(to: CGPoint(x: rect.midX, y: rect.minY))
                p.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
                p.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
                p.closeSubpath()
            }
        }
    }
    
    @State var value: Double = 0.0
    var body: some View {
        VStack {
            SemiCircleGaugeMeter($value, valueMarkStyle: Color.white) {
                NeedleShape().frame(width: 10.0, height: 80.0)
            }.arcWidth(15.0).valueMarkSize(25.0).frame(width: 300.0, height: 200.0)
            Slider(value: $value, in: 0.0...100.0)
        }
    }
}

#Preview {
    Demo().background(Color.blue)
}
