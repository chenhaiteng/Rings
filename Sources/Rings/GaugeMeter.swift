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

/// A gauge meter is use to display value.
public struct GaugeMeter<Layers:Sequence>: View where Layers.Element: AngularLayer {
    private var layers: Layers
    
    private var mappingObj: KnobMapping
    
    public var offset: CGPoint = .zero
    private var radius: Double
    private var value: Double
    
    @State private var startValue: Double = .nan
    
    /// Create a gauge meter to diplay value with the given radius, mapping relation between value and degree, and components to compose it.
    /// - Parameters:
    ///   - value: The value to show in gauge meter.
    ///   - radius: The radius of the gauge meter, default is 100.0.
    ///   - mapping: The mapping object to transform value to degree. The default mapping will map the value in 0...1.0 into degrees -180.0...0.0 linearly.
    ///   - components: A builder which building the layers to compose the gague meter.
    public init<F:BinaryFloatingPoint>(value: F, radius: Double = 100.0, mapping: KnobMapping = LinearMapping(degreeRange: -180.0...0.0), @SequenceBuilder _ components: ()->Layers) {
        self.radius = radius
        self.value = Double(value)
        mappingObj = mapping
        layers = components()
    }
    
    public var body: some View {
        ZStack(alignment: .center) {
            ForEach(sequence: layers) { (index, layer) in
                layer.mappingValue(value, with: mappingObj).radius(radius).offset(dx: offset.x, dy: offset.y).body.frame(width: radius * 2.0, height: radius * 2.0)
            }
        }
    }
}

extension GaugeMeter: Adjustable {
    /// Offset the gauge meter by the horizontal and vertical amount.
    /// - Parameters:
    ///   - dx: The horizontal distance to offset.
    ///   - dy: The vertical distance to offset.
    /// - Returns: A gauage meter that offsets itself by x and y.
    func offset<F: BinaryFloatingPoint>(dx:F = 0.0, dy:F = 0.0) -> Self {
        setProperty { adjustObject in
            adjustObject.offset = CGPoint(x: Double(dx), y: Double(dy))
        }
    }
}

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

#Preview {
    Demo()
}

