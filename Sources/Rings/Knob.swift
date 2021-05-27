//
//  Knob.swift
//  
//
//  Created by Chen-Hai Teng on 2021/5/21.
//

import SwiftUI

    }
}

        get {
        }
        }
    }
    
        }
        }
    }
    
        }
        }
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
    // atan2 only holds when x > 0.
    // When x < 0, the angle apparent from the expression above is
    // pointing in the opposite direction of the correct angle,
    // and a value of π (or 180°) must be either added or subtracted
    // from θ to put the Cartesian point (x, y) into the correct quadrant
    // of the Euclidean plane.
    static func adjustedAtan2<T>(y: T ,x: T) -> T where T: BinaryFloatingPoint {
        let result = atan2(CGFloat(y), CGFloat(x))
        return T(result + ((x < 0 && y < 0) ? 2*CGFloat.pi : 0))
    }
    
    static func crossQuadrant34(v1: CGVector, v2: CGVector) -> Bool {
        return (v1.dy*v2.dy > 0 && v2.dx*v1.dx < 0)
    }
    
    static func angularDistance(v1: CGVector, v2: CGVector) -> Angle {
        let angle2 = adjustedAtan2(y: v2.dy, x: v2.dx)
        let angle1 = adjustedAtan2(y: v1.dy, x: v1.dx)
        if(crossQuadrant34(v1: v1, v2: v2)) { // v1, v2 cross quadrant 3 and 4
            return Angle.radians(Double(atan2(v2.dy, v2.dx) - atan2(v1.dy, v1.dx)))
        } else {
            return Angle(radians: Double(angle2 - angle1))
        }
    }
    
    func angle(_ shouldAdjust: Bool = false) -> Angle {
        return Angle.radians(Double(radians(shouldAdjust)))
    }
    
    func radians(_ shouldAdjust: Bool = false) -> CGFloat {
        return shouldAdjust ? CGVector.adjustedAtan2(y: dy, x: dx) : atan2(dy, dx)
    }
    
    func degrees(_ shouldAdjust: Bool = false) -> CGFloat {
        return CGFloat(angle(shouldAdjust).degrees)
    }
}

public struct Knob: View {
    private var layers: [AnyKnobLayer]  = []
    
    private var mappingObj: KnobMapping
    
    @Binding var value: Double
    @GestureState var currentVector: CGVector = .zero
    
    private var blueprint: Bool = false
    
    @State var nextVector: CGVector = .zero
    @State var deltaAngle: Angle = .zero
    @State var startVector: CGVector = .zero
    @State private var startValue: Double = .nan
    
    init<F: BinaryFloatingPoint>(_ value: Binding<F>, _ mapping: KnobMapping = LinearMapping()) {
        _value = Binding<Double>(get: {
            Double(value.wrappedValue)
        }, set: { v in
            value.wrappedValue = F(v)
        })
        mappingObj = mapping
    }
    public var body: some View {
        GeometryReader { geo in
            let center = CGPoint(x: geo.size.width/2, y: geo.size.height/2)
            let radius = min(geo.size.width, geo.size.height)/2.0
            
            let pt = CGPoint(x: center.x + currentVector.dx, y: center.y - currentVector.dy)
            let startPt = CGPoint(x: center.x + startVector.dx, y: center.y - startVector.dy)
            ZStack {
                ForEach(layers.indices) { index in
                    layers[index].degreeRange(mappingObj.degreeRange).degree(mappingObj.degree(from: value)).view.frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                }
                Group {
                    Path { p in
                        p.move(to: CGPoint(x: center.x - radius, y: center.y))
                        p.addLine(to: CGPoint(x: center.x + radius, y: center.y))
                        p.move(to: CGPoint(x: center.x, y: center.y - radius))
                        p.addLine(to: CGPoint(x: center.x, y: center.y + radius))
                        p.addEllipse(in: CGRect(x: center.x - radius, y: center.y - radius, width: 2*radius, height: 2*radius))
                    }.stroke(Color.blue.opacity(0.5))
                    Path { p in
                        p.move(to: center)
                        p.addLine(to: pt)
                    }.stroke(Color.blue.opacity(0.5))
                    Path { p in
                        p.move(to: center)
                        p.addLine(to: startPt)
                    }.stroke(Color.red.opacity(0.5))
                }.if(!blueprint) { content in
                    content.hidden()
                }
            }.contentShape(Circle()).gesture(DragGesture().onChanged({ value in
                if(currentVector != CGVector.zero) {
                    if(startValue.isNaN) {
                        startValue = self.value
                    }
                    startVector = value.startLocation - center
                    nextVector = value.location - center
                    
                    let shouldAdjust = !CGVector.crossQuadrant34(v1: nextVector, v2: currentVector)
                    
                    let valueStart = KnobGestureRecord.Value(value: startValue, angle: startVector.angle(shouldAdjust))
                    
                    let valueCurrent = KnobGestureRecord.Value(value: self.value, angle: currentVector.angle(shouldAdjust))
                    
                    let valueNext = KnobGestureRecord.Value(angle: nextVector.angle(shouldAdjust))
                    
                    let _degree = mappingObj.degree(from: self.value)
                    if _degree >= mappingObj.degreeRange.upperBound {
                        if valueCurrent.angle.degrees > valueNext.angle.degrees {
                            return
                        }
                    }
                    
                    if _degree <= mappingObj.degreeRange.lowerBound {
                        if valueCurrent.angle.degrees < valueNext.angle.degrees {
                            return
                        }
                    }
                    
                    let record = KnobGestureRecord(start: valueStart, current:valueCurrent, next:valueNext)
                    let newValue = mappingObj.newValue(record)
                    if !newValue.isNaN {
                        if(self.value != newValue) {
                            self.value = newValue
                        }
                    }
                }
            }).onEnded({ value in
                nextVector = .zero
                deltaAngle = .zero
                startValue = .nan
                startVector = .zero
            }).updating($currentVector, body: { value, state, transaction in
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
            tmp.mappingObj = mapping
        }
    }
    
    func blueprint(_ show: Bool) -> Self {
        setProperty { tmp in
            tmp.blueprint = show
        }
    }
}

struct KnobDemo: View {
    @State var valueSegmented: CGFloat = 0
    @State var valueContiune: CGFloat = 0
    @State var ringWidth: CGFloat = 5
    @State var arcWidth: CGFloat = 5
    @State var showBlueprint: Bool = false
    let gradient = AngularGradient(gradient: Gradient(colors: [Color.red, Color.blue]), center: .center)
    var body: some View {
        VStack {
            Spacer(minLength: 40)
            HStack {
                VStack {
                    Knob($valueContiune).addLayer(RingKnobLayer().ringColor(Gradient(colors: [.red, .blue, .blue, .blue, .blue, .blue, .red])).ringWidth(ringWidth)).addLayer(ArcKnobLayer().arcWidth(arcWidth)).blueprint(showBlueprint)
                    Slider(value: $valueContiune, in: 0.0...1.0) {
                        Text(String(format: "value: %.2f", valueContiune))
                    }
                }
                VStack {
                    Knob($valueSegmented).addLayer(RingKnobLayer().ringColor(Gradient(colors: [.blue, .red, .red, .red, .red, .red, .blue])).ringWidth(ringWidth)).addLayer(ArcKnobLayer().arcWidth(arcWidth)).blueprint(showBlueprint).mapping(with: SegmentMapping().stops([KnobStop(0.0, -215.0), KnobStop(1.0, 45.0), KnobStop(0.5, -90.0), KnobStop(0.2, 0.0), KnobStop(0.8, -180.0), KnobStop(0.3, -135)]))
                    Slider(value: $valueSegmented, in: 0.0...1.0, step: 0.1) {
                        Text(String(format: "value: %.2f", valueSegmented))
                    }
                }
            }
            Spacer(minLength: 40)
            Group {
                Slider(value: $ringWidth, in: 5.0...25.0, step: 1.0) {
                    Text(String(format: "Ring Width: %.2f", ringWidth))
                }
                Slider(value: $arcWidth, in: 5.0...25.0, step: 1.0) {
                    Text(String(format: "Arc Width: %.2f", arcWidth))
                }
                Toggle("blue print", isOn: $showBlueprint)
            }
        }
    }
}

struct Knob_Previews: PreviewProvider {
    static var previews: some View {
        KnobDemo()
    }
}
