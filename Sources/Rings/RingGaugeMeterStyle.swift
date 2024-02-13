//
//  RingGaugeMeterStyle.swift
//
//
//  Created by Chen Hai Teng on 2/8/24.
//

import SwiftUI
import SequenceBuilder

struct GaugePointer: Shape {
    func path(in rect: CGRect) -> Path {
        Path { p in
            p.move(to: CGPoint(x: rect.minX, y: rect.maxY*0.8))
            p.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
            p.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY*0.8))
            p.addQuadCurve(to: CGPoint(x:rect.midX, y:rect.minY), control: CGPoint(x: rect.maxX*0.8, y:rect.maxY*0.6))
            p.addQuadCurve(to: CGPoint(x: rect.minX, y: rect.maxY*0.8), control: CGPoint(x: rect.maxX*0.2, y:rect.maxY*0.6))
            
        }
    }
}

@available(iOS 16.0, macOS 13.0, watchOS 7.0, *)
@available(tvOS, unavailable)
enum RingGaugeMeterStyle {
    public struct CustomStyle<Layers:Sequence>: GaugeStyle where Layers.Element : AngularLayer {
        private var radius: Double
        let degreeRange: ClosedRange<Double>
        private var layers: () -> Layers
        public func makeBody(configuration: Configuration) -> some View {
            let size = radius * 2.0
            VStack {
                ZStack {
                    GaugeMeter(value: configuration.value, radius:radius, mapping: LinearMapping(degreeRange: degreeRange), layers).frame(width: size , height: size)
                    configuration.currentValueLabel.offset(y: radius * 0.5)
                }
                HStack {
                    configuration.minimumValueLabel.frame(alignment: .leading)
                    Spacer()
                    configuration.maximumValueLabel.frame(alignment: .trailing)
                }.frame(width: size)
                configuration.label
            }
        }
        
        public init(radius: Double = 50.0 , degreeRange:ClosedRange<Double> = -225.0...45.0, @SequenceBuilder _ layers: @escaping () -> Layers) {
            self.radius = radius
            self.layers = layers
            self.degreeRange = degreeRange
        }
    }
    
    public struct SemiCircleStyle<V, M> : GaugeStyle where V : View, M : View {
        private let trackerSize: Double
        private let trackerStyle: StrokeStyle
        private let needleAnchor: UnitPoint
        private let indicator: () -> V
        private let valueMarkSize: Double
        private let valueMark: () -> M
        func makeBody(configuration: Configuration) -> some View {
            GeometryReader { geo in
                let r = geo.width/2.0 - trackerSize
                GaugeMeter(value: configuration.value, radius: r,
                           mapping: LinearMapping(degreeRange: -180.0...0.0)) {
                    GaugeTrackLayer().arcColor(progressColor).arcWidth(trackerSize).style(trackerStyle)
                    GauageNeedleLayer(center: needleAnchor) {
                        indicator()
                    }
                    GaugeValueMarkLayer(valueMarkSize) {
                        valueMark()
                    }
                }.frame(width: 2.0*r, height: 2.0*r).offset(x:trackerSize, y: geo.height - r - trackerSize)
            }
        }
        
        init(trackerSize: Double = 5.0, trackerStyle: StrokeStyle = StrokeStyle(dash:[3.0, 3.0]), needleAnchor: UnitPoint = .center, indicator: @escaping () -> V, valueMarkSize: Double = 10.0, valueMark: @escaping () -> M = { Circle().fill(Color.white) }) {
            self.trackerSize = trackerSize
            self.trackerStyle = trackerStyle
            self.needleAnchor = needleAnchor
            self.indicator = indicator
            self.valueMarkSize = valueMarkSize
            self.valueMark = valueMark
        }
    }
}

@available(iOS 16.0, macOS 13.0, watchOS 7.0, *)
@available(tvOS, unavailable)
fileprivate struct GaugeDemo: View {
    @State var value: Double = 25.0
    var body: some View {
        VStack {
            Gauge(value: value, in: 0...50.0, label: {
                Text("Custom Gauge")
            }, currentValueLabel: {
                Text("\(value, specifier: "%.2f")")
            }, minimumValueLabel: {
                ZStack {
                    Text("0.0").offset(y: -10.0)
                }
            }, maximumValueLabel: {
                ZStack {
                    Text("50.0").offset(y: -10.0)
                }
            }
            ).gaugeStyle(RingGaugeMeterStyle.CustomStyle(radius: 75.0) {
                ArcKnobLayer(fixed: true)
                    .arcColor {
                        Color.green.opacity(0.3)
                        Color.yellow.opacity(0.3)
                        Color.red.opacity(0.3)
                    }.arcWidth(20.0).style(StrokeStyle(dash:[3.0, 3.0]))
                ArcKnobLayer()
                    .arcColor {
                        Color.green
                        Color.yellow
                        Color.red
                    }.arcWidth(20.0).style(StrokeStyle(dash:[3.0, 3.0]))
                GauageNeedleLayer(center: .center) {
                    ZStack {
                        GaugePointer().frame(width: 8.0, height: 70.0).offset(y: 10.0)
                    }
                }
                GaugeValueMarkLayer(20.0) {
                    Circle().fill(Color.white)
                }
            }).frame(width: 200.0, height: 250.0)
            Slider(value: $value,in: 0.0...50.0).frame(width: 200.0)
        }
    }
}

@available(iOS 16.0, macOS 13.0, watchOS 7.0, *)
@available(tvOS, unavailable)
fileprivate struct SemiGaugeDemo : View {
    @State var value: Double = 25.0
    var body: some View {
        VStack {
            Gauge(value: value, in: 0.0...50.0){}.gaugeStyle(RingGaugeMeterStyle.SemiCircleStyle(needleAnchor: UnitPoint(x:0.5, y:0.45), indicator: {
                GaugePointer().frame(width: 8.0, height: 60.0).offset(y:20.0)
            })).frame(width:200.0, height: 100.0)
            Slider(value: $value,in: 0.0...50.0).frame(width: 200.0)
        }.padding(20.0)
    }
}

#Preview {
    VStack {
        if #available(iOS 16.0, macOS 13.0, watchOS 7.0, *) {
            GaugeDemo()
            SemiGaugeDemo()
        }
    }
}
