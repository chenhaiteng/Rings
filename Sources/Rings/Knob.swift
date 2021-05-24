//
//  Knob.swift
//  
//
//  Created by Chen-Hai Teng on 2021/5/21.
//

import SwiftUI

public protocol KnobMapping {
    func degree(from value: Double) -> Double
    func degree(delta value: Double) -> Double
    func value(from degree: Double) -> Double
    func value(delta degree: Double) -> Double
    func configure(with knob: Knob) -> Self
}

extension KnobMapping {
    func configure(with knob: Knob) -> Self {
        return self
    }
}

public struct LinearMapping : KnobMapping, Adjustable {
    var minDegree: Double = -225
    var maxDegree: Double = 45
    var minValue: Double = 0.0
    var maxValue: Double = 1.0
    
    public func degree(from value: Double) -> Double {
        if(value < minValue) {
            return minDegree
        }
        if(value > maxValue) {
            return maxDegree
        }
        let ratio = (value - minValue)/(maxValue - minValue)
        return ratio * (maxDegree - minDegree) + minDegree
    }
    
    public func degree(delta value: Double) -> Double {
        return value * (maxDegree - minDegree) / (maxValue - minValue)
    }
    
    public func value(from degree: Double) -> Double {
        if(degree < minDegree) {
            return minValue
        }
        if(degree > maxDegree) {
            return maxValue
        }
        let ratio = (degree - minDegree)/(maxDegree - minDegree)
        return ratio * (maxValue - minValue) + minValue
    }
    
    public func value(delta degree: Double) -> Double {
        return degree * (maxValue - minValue) / (maxDegree - minDegree)
    }
    
    public func configure(with knob: Knob) -> Self {
        setProperty { tmp in
            tmp.minDegree = knob.minDegree
            tmp.maxDegree = knob.maxDegree
            tmp.minValue = knob.minValue
            tmp.maxValue = knob.maxValue
        }
    }
}

extension CGPoint {
    static func -(left: CGPoint, right: CGPoint) -> CGVector {
        // The origin of View's coordinate is on left-top, adjust it to left-bottom to fit mathmatic behaviour.
        return CGVector(dx: left.x - right.x, dy: right.y - left.y)
    }
}

extension CGVector {
    
    static func adjustedAtan2<T>(y: T ,x: T) -> T where T: BinaryFloatingPoint {
        let result = atan2(CGFloat(y), CGFloat(x))
        return T(result + (y < 0 ? 2*CGFloat.pi : 0))
    }
    
    static func angularDistance(v1: CGVector, v2: CGVector) -> Angle {
        let angle2 = adjustedAtan2(y: v2.dy, x: v2.dx)
        let angle1 = adjustedAtan2(y: v1.dy, x: v1.dx)
        return Angle(radians: Double(angle2 - angle1))
    }
}

public struct Knob: View {
    private var layers: [AnyKnobLayer]  = []
    var minDegree: Double = -225
    var maxDegree: Double = 45
    var minValue: Double = 0.0
    var maxValue: Double = 1.0
    
    private var mappingObj: KnobMapping = LinearMapping()
    
    @Binding var value: Double
    @GestureState var previousVector: CGVector = .zero
    
    //Debug State
    @State var currentVector: CGVector = .zero
    @State var deltaAngle: Angle = .zero
    @State var currentAngle: Angle = .zero
    @State var prevsAngle: Angle = .zero
    
    
    init<F: BinaryFloatingPoint>(_ value: Binding<F>) {
        _value = Binding<Double>(get: {
            Double(value.wrappedValue)
        }, set: { v in
            value.wrappedValue = F(v)
        })
    }
    
    public var body: some View {
        GeometryReader { geo in
            let center = CGPoint(x: geo.size.width/2, y: geo.size.height/2)
            let radius = min(geo.size.width, geo.size.height)/2.0
            let mapping = mappingObj.configure(with: self)
            
            let pt = CGPoint(x: center.x + previousVector.dx, y: center.y - previousVector.dy)
            
            ZStack {
                Path { p in
                    p.move(to: CGPoint(x: center.x - radius, y: center.y))
                    p.addLine(to: CGPoint(x: center.x + radius, y: center.y))
                    p.move(to: CGPoint(x: center.x, y: center.y - radius))
                    p.addLine(to: CGPoint(x: center.x, y: center.y + radius))
                }.stroke()
                Path { p in
                    p.move(to: center)
                    p.addLine(to: pt)
                }.stroke()
                HStack {
                    VStack {
                        Text("current")
                        Text(String(format: "x: %.2f, y:%.2f", currentVector.dx, currentVector.dy)).frame(height: 20)
                        Text(String(format: "angle: %.2f", currentAngle.degrees))
                        Divider()
                        Text("previous")
                        Text(String(format: "x: %.2f, y:%.2f", previousVector.dx, previousVector.dy)).frame(height: 20)
                        Text(String(format: "angle: %.2f", prevsAngle.degrees))
                        Divider()
                        Text(String(format: "delta Angle: %.2f", deltaAngle.degrees))
                    }.frame(width: 120)
                    Spacer()
                }
                ForEach(layers.indices) { index in
                    layers[index].degreeRange(minDegree...maxDegree).degree(mapping.degree(from: value)).view.frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                }
            }.contentShape(Circle()).gesture(DragGesture().onChanged({ value in
                if(previousVector != CGVector.zero) {
                    currentVector = value.location - center
                    currentAngle = Angle.radians(Double(CGVector.adjustedAtan2(y: currentVector.dy, x: currentVector.dx)))
                    prevsAngle = Angle.radians(Double(CGVector.adjustedAtan2(y: previousVector.dy, x: previousVector.dx)))
                    deltaAngle = CGVector.angularDistance(v1: currentVector, v2: previousVector)
                    let deltaValue = mapping.value(delta: deltaAngle.degrees)
                    self.value += deltaValue
                }
            }).onEnded({ value in
                currentVector = .zero
                deltaAngle = .zero
                prevsAngle = .zero
                currentAngle = .zero
            }).updating($previousVector, body: { value, state, transaction in
                state = value.location - center
            }))
        }
    }
}

extension Knob : Adjustable {
    func addLayer<L>(_ layer: L) -> Self where L : KnobLayer {
        setProperty { tmp in
            tmp.layers.append(AnyKnobLayer(layer))
        }
    }
    
    func mapping<T: KnobMapping>(with mapping: T) -> Self {
        setProperty { tmp in
            tmp.mappingObj = mapping.configure(with: tmp)
        }
    }
}

struct KnobDemo: View {
    @State var testValue: CGFloat = 0
    @State var ringWidth: CGFloat = 5
    @State var arcWidth: CGFloat = 5
    var body: some View {
        VStack {
            Knob($testValue).addLayer(RingKnobLayer().ringColor(Color.blue).ringWidth(ringWidth)).addLayer(ArcKnobLayer())
            Slider(value: $ringWidth, in: 5.0...25.0, step: 1.0) {
                Text(String(format: "Ring Width: %.2f", ringWidth))
            }
            Slider(value: $arcWidth, in: 5.0...25.0, step: 1.0) {
                Text(String(format: "Arc Width: %.2f", arcWidth))
            }
            Slider(value: $testValue, in: 0.0...1.0) {
                Text("test value")
            }
        }
    }
}

struct Knob_Previews: PreviewProvider {
    static var previews: some View {
        KnobDemo()
    }
}
