//
//  ArcKnobLayer.swift
//  
//
//  Created by Chen-Hai Teng on 2021/5/22.
//

import SwiftUI
import Common
import GradientBuilder

extension StrokeStyle {
    func width(_ w: CGFloat) -> Self {
        var copy = self
        copy.lineWidth = w
        return copy
    }
}

public struct ArcKnobLayer : AngularLayer {
    public var isFixed: Bool
    
    @Clamping(-225.0...45.0) public var degree: Double = 120.0
    public var degreeRange: ClosedRange<Double> {
        get {
            $degree
        }
        set {
            $degree = newValue
        }
    }
    
    
    private var arcWidth: CGFloat = 5.0
    private var gradient: Gradient = Gradient(colors: [.white])
    private var style: StrokeStyle = StrokeStyle()
    
    public var body: some View {
        get {
            ZStack {
                GeometryReader { geo in
                    let radius = min(geo.size.height, geo.size.width)/2.0 - arcWidth/2.0
                    Path { p in
                        p.addArc(center: CGPoint(x: geo.size.width/2, y: geo.size.height/2), radius: radius, startAngle: Angle.degrees(degreeRange.lowerBound), endAngle: isFixed ? Angle.degrees(degreeRange.upperBound) : Angle.degrees(Double(degree)), clockwise: false)
                    }.stroke(AngularGradient(gradient: gradient, center: .center, startAngle: Angle.degrees(degreeRange.lowerBound)), style:style.width(arcWidth))
                }
            }
        }
    }
    
    init(fixed: Bool = false) {
        isFixed = fixed
    }
}

extension ArcKnobLayer : Adjustable {
    public func arcWidth<F>(_ width:F) -> Self where F: BinaryFloatingPoint {
        setProperty { tmp in
            tmp.arcWidth = CGFloat(width)
        }
    }
    
    public func arcColor(@GradientBuilder _ builder:()->Gradient) -> Self {
        setProperty { tmp in
            tmp.gradient = builder()
        }
    }
    
    public func style(_ style: StrokeStyle) -> Self {
        setProperty { tmp in
            tmp.style = style
        }
    }
}

struct ArcLayerDemo: View {
    @State var degree: Double = -75.0
    var body: some View {
        VStack {
            HStack {
                ArcKnobLayer(fixed: true).arcWidth(5.0).arcColor {
                    (Color.green.opacity(0.3), 0.6)
                    (Color.yellow.opacity(0.3), 0.7)
                    (Color.yellow.opacity(0.3), 0.9)
                    (Color.red.opacity(0.3), 0.95)
                }.degree(degree).body
                
                ArcKnobLayer().arcWidth(5.0).arcColor {
                    (Color.green, 0.6)
                    (Color.yellow, 0.7)
                    (Color.yellow, 0.9)
                    (Color.red, 0.95)
                }.degree(degree).body
                
                ArcKnobLayer(fixed:true).arcWidth(5.0).arcColor {
                    (Color.green, 0.6)
                    (Color.yellow, 0.7)
                    (Color.yellow, 0.9)
                    (Color.red, 0.95)
                }.style(StrokeStyle(lineCap: .butt, lineJoin: .miter, miterLimit: 1.0, dash: [5.0,2.0], dashPhase: 1.0)).arcWidth(30.0).degree(degree).body
            }.padding()
            Slider(value: $degree, in: -225.0...45.0, label: {
                Text("Degree")
            }).padding()
        }
    }
}

struct ArcLayerPreview : PreviewProvider {
    static var previews: some View {
        ArcLayerDemo()
    }
}
