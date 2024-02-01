//
//  GaugeMeter.swift
//
//
//  Created by Chen Hai Teng on 1/31/24.
//

import SwiftUI
import Common
import CoreGraphics
import CoreGraphicsExtension
import SequenceBuilder

public struct GaugeMeter<Layers:Sequence>: View where Layers.Element: AngularLayer {
    private var layers: Layers
    
    private var mappingObj: KnobMapping
    
    public var offset: CGPoint = .zero
    
    @Binding var value: Double
//    
//    private var blueprint: Bool = false

    @State private var startValue: Double = .nan
    
    public init<F:BinaryFloatingPoint>(_ value: Binding<F>, _ mapping: KnobMapping = LinearMapping(degreeRange: -180.0...0.0), @SequenceBuilder _ builder: ()->Layers) {
        _value = Binding<Double>(get: {
            Double(value.wrappedValue)
        }, set: { v in
            value.wrappedValue = F(v)
        })
        mappingObj = mapping
        layers = builder()
    }
    
    public var body: some View {
        GeometryReader { geo in
            let radius = min(geo.width, geo.height)/2.0
            
            ZStack(alignment: .center){
                ForEach(sequence: layers) { (index, layer) in
                    layer.mappingValue(value, with: mappingObj).radius(radius).offset(dx: offset.x, dy: offset.y).body.frame(width: geo.size.width, height: geo.size.height)
                }
            }
            
        }
    }
}

extension GaugeMeter: Adjustable {
    func offset<F: BinaryFloatingPoint>(dx:F = 0.0, dy:F = 0.0) -> Self {
        setProperty { adjustObject in
            adjustObject.offset = CGPoint(x: Double(dx), y: Double(dy))
        }
    }
}

struct GaugeMeterDemo: View {
    private static let demoRange: ClosedRange<CGFloat> = 0.0...50.0
    @State var valueContiune: CGFloat = 0.0 /*demoRange.lowerBound*/
    @State var ringWidth: CGFloat = 5
    @State var arcWidth: CGFloat = 5
    @State var showBlueprint: Bool = true
    @State var needleBase: UnitPoint = .center
    
    let gradient = AngularGradient(gradient: Gradient(colors: [Color.red, Color.blue]), center: .center)
    var body: some View {
        VStack {
            Spacer(minLength: 40)
            HStack {
                VStack {
                    GaugeMeter($valueContiune, LinearMapping(degreeRange: -180.0...0.0, valueRange: GaugeMeterDemo.demoRange.toDoubleRange())) {
                        ArcKnobLayer(fixed: true)
                            .arcColor {
                                Color.green.opacity(0.3)
                                Color.yellow.opacity(0.3)
                                Color.red.opacity(0.3)
                            }.arcWidth(ringWidth).style(StrokeStyle(dash:[3.0, 3.0]))
                        ArcKnobLayer()
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
                Slider(value: $valueContiune, in: GaugeMeterDemo.demoRange) {
                    Text(String(format: "Value: %.2f", valueContiune))
                }
                HStack {
                    Text("Needle base")
                    Slider(value: $needleBase.x, in: 0.0...1.0, step: 0.1) { Text(String(format:"x: %.2f", needleBase.x))}
                    Slider(value: $needleBase.y, in: 0.0...1.0, step: 0.1){ Text(String(format:"y: %.2f", needleBase.y))}
                }
                Slider(value: $ringWidth, in: 5.0...25.0, step: 1.0) {
                    Text(String(format: "Track Width: %.2f", ringWidth))
                }
                Slider(value: $arcWidth, in: 5.0...25.0, step: 1.0) {
                    Text(String(format: "Indicator Width: %.2f", arcWidth))
                }
                Toggle("blue print", isOn: $showBlueprint)
            }.padding(EdgeInsets(top: 0.0, leading: 10.0, bottom: 0.0, trailing: 10.0))
        }
    }
}

#Preview {
    GaugeMeterDemo()
}
