//
//  SwiftUIView.swift
//  Rings
//
//  Created by Chen Hai Teng on 10/6/24.
//

import SwiftUI
import Rings

fileprivate struct Demo: View {
    private static let demoRange: ClosedRange<CGFloat> = 0.0...50.0
    @State var valueContiune: CGFloat = 0.0 /*demoRange.lowerBound*/
    @State var arcWidth: CGFloat = 5
    @State var showBlueprint: Bool = true
    @State var needleBase: UnitPoint = .center
    
    var body: some View {
        VStack {
            Spacer(minLength: 40)
            HStack {
                VStack {
                    GaugeMeter(value: valueContiune, mapping: LinearMapping(degreeRange: -180.0...0.0, valueRange: Demo.demoRange.toDoubleRange())) {
                        GaugeTrackLayer()
                            .arcColor {
                                Color.green
                                Color.yellow
                                Color.red
                            }.arcWidth(arcWidth).style(StrokeStyle(dash:[3.0, 3.0]))
                        GauageNeedleLayer(center: needleBase) {
                            VStack(spacing:0.0) {
                                Circle().frame(width: 12.0, height: 12.0)
                                Rectangle().frame(width: 2.0, height: 20.0)
                            }
                        }.blueprint(showBlueprint)
                        GaugeValueMarkLayer {
                            Circle()
                        }
                    }.if(showBlueprint) { view in
                        view.border(Color.blue)
                    }
                }
            }
            Group {
                Slider(value: $valueContiune, in: Demo.demoRange) {
                    Text(String(format: "Value: %.2f", valueContiune))
                }
                HStack {
                    Text("Needle base")
                    Slider(value: $needleBase.x, in: 0.0...1.0, step: 0.1) { Text(String(format:"x: %.2f", needleBase.x))}
                    Slider(value: $needleBase.y, in: 0.0...1.0, step: 0.1){ Text(String(format:"y: %.2f", needleBase.y))}
                }
                Slider(value: $arcWidth, in: 5.0...25.0, step: 1.0) {
                    Text(String(format: "Indicator Width: %.2f", arcWidth))
                }
                Toggle("blue print", isOn: $showBlueprint)
            }.padding(EdgeInsets(top: 0.0, leading: 10.0, bottom: 0.0, trailing: 10.0))
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
                        GaugeNeedle().frame(width: 8.0, height: 70.0).offset(y: 10.0)
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
            Gauge(value: value, in: 0.0...50.0){}.gaugeStyle(RingGaugeMeterStyle.SemiCircleStyle(needleAnchor: UnitPoint(x:0.5, y:0.45), needleView: {
                GaugeNeedle().frame(width: 8.0, height: 60.0).offset(y:20.0)
            })).frame(width:200.0, height: 100.0)
            Slider(value: $value,in: 0.0...50.0).frame(width: 200.0)
        }.padding(20.0)
    }
}

fileprivate struct SemiCircleGaugeDemo : View {
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
    VStack {
        Text("available on all platforms").padding(.top, 24.0)
        Demo()
        SemiCircleGaugeDemo()
        Divider()
        if #available(iOS 16.0, macOS 13.0, watchOS 7.0, *) {
            Text("for iOS 16.0, macOS 13.0, watchOS 7.0")
            GaugeDemo()
            SemiGaugeDemo()
        }
    }
}
