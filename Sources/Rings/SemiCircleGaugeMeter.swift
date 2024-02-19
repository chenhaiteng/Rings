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

/// An easy gauge meter with semi-circular shape.
public struct SemiCircleGaugeMeter<V: BinaryFloatingPoint, N: View, S: ShapeStyle>: View {
    
    @Binding private var value: V
    private let range: ClosedRange<Double>
    private var needleAnchor: UnitPoint
    private var arcWidth = 10.0
    private var indicator: ()->N
    private var valueMarkStyle: S
    private var valueMarkSize: Double = 12.0
    private var trackStyle: StrokeStyle = StrokeStyle(dash:[3.0, 3.0])
    
    public var body: some View {
        GeometryReader { geo in
            let r = geo.width/2.0 - arcWidth
            GaugeMeter(value: value, radius: r,
                       mapping: LinearMapping(degreeRange: -180.0...0.0, valueRange: range)) {
                ArcKnobLayer(fixed: true)
                    .arcColor (trackColor).arcWidth(arcWidth).style(trackStyle)
                ArcKnobLayer()
                    .arcColor(progressColor).arcWidth(arcWidth).style(trackStyle)
                GauageNeedleLayer(center: needleAnchor) {
                    indicator()
                }
                GaugeValueMarkLayer(valueMarkSize) {
                    Circle().fill(valueMarkStyle).shadow(radius: min(valueMarkSize/4.0, 5.0))
                }
            }.frame(width: 2.0*r, height: 2.0*r).offset(x:arcWidth, y: geo.height - r - arcWidth)
        }
    }
    
    /// Create a semi-circular gauge meter to diplay value in given range with customizable needle indicator.
    /// - Parameters:
    ///   - value: The value to show in gauge meter.
    ///   - range: The range of value. Default between 0.0...100.0
    ///   - needleAnchor: The unit point to specified where the needle indicator located. The default value is [center](https://developer.apple.com/documentation/swiftui/unitpoint/center)
    ///   - valueMarkStyle: The style of value mark.
    ///   - indicator: The builder of customizable indicator. The default shape is a triangle with fixed size {10.0, 15.0}
    public init(_ value: Binding<V>, range: ClosedRange<Double> = 0.0...100.0, needleAnchor: UnitPoint = .center, valueMarkStyle: S = Color.clear, @ViewBuilder _ indicator: @escaping () -> N = {
        VStack(spacing:0.0) {
            Image(systemName: "triangleshape.fill").resizable().frame(width: 10.0, height: 15.0)
        Rectangle().frame(width: 2.0, height: 50.0)
        }
    }) {
        self._value = value
        self.range = range
        self.needleAnchor = needleAnchor
        self.indicator = indicator
        self.valueMarkStyle = valueMarkStyle
    }
}

extension SemiCircleGaugeMeter: Adjustable {
    /// Adjust the location of the needle indicator.
    /// - Parameter anchor: The unit point to specified where the needle indicator located.
    /// - Returns: A semi circular gauge meter
    public func needleAnchor(_ anchor: UnitPoint) -> Self {
        setProperty { adjustObject in
            adjustObject.needleAnchor = anchor
        }
    }
    
    /// Adjust the track width with specified value.
    /// - Parameter value: The width of track
    /// - Returns: A semi circular gauge meter
    public func trackWidth<F: BinaryFloatingPoint>(_ value: F) -> Self {
        setProperty { adjustObject in
            adjustObject.arcWidth = Double(value)
        }
    }
    
    /// Specifies the size of value mark.
    /// - Parameter size: The size of value mark.
    /// - Returns: A semi circular gauge meter
    public func valueMarkSize<F: BinaryFloatingPoint>(_ size: F) -> Self {
        setProperty { adjustObject in
            adjustObject.valueMarkSize = Double(size)
        }
    }
    
    /// Specifies how the track is draw.
    /// - Parameter style: The stroke style of track. Refer to [stroke style](https://developer.apple.com/documentation/swiftui/strokestyle) for more detail.
    /// - Returns: A semi circular gauge meter
    public func trackStyle(_ style: StrokeStyle) -> Self {
        setProperty { adjustObject in
            adjustObject.trackStyle = style
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
            }.trackWidth(15.0).valueMarkSize(25.0).frame(width: 300.0, height: 200.0)
            Slider(value: $value, in: 0.0...100.0)
        }
    }
}

#Preview {
    Demo().background(Color.blue)
}
