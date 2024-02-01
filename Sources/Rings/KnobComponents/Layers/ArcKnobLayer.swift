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

/**
 ArcKnobLayer implements an angular layer that drawing arc based on specified degree.
 
 This struct allows developer to create fixed or non-fixed arc. A *fixed* layer draws a arc based on degreeRange, and a *non-fixed* layer draws  by degreeRange and its degree.
 
 */
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
    
    public var offset: CGPoint = .zero
    
    public var radius: CGFloat = 100.0
    
    private var arcWidth: CGFloat = 5.0
    private var gradient: Gradient = Gradient(colors: [.white])
    private var style: StrokeStyle = StrokeStyle()
    
    public var body: some View {
        get {
            ZStack {
                GeometryReader { geo in
                    Path { p in
                        p.addArc(center: CGPoint(x: geo.size.width/2, y: geo.size.height/2), radius: radius, startAngle: Angle.degrees(degreeRange.lowerBound), endAngle: isFixed ? Angle.degrees(degreeRange.upperBound) : Angle.degrees(Double(degree)), clockwise: false)
                    }.offsetBy(dx: offset.x, dy: offset.y).stroke(AngularGradient(gradient: gradient, center: .center, startAngle: Angle.degrees(degreeRange.lowerBound)), style:style.width(arcWidth))
                }
            }
        }
    }
    
    public init(fixed: Bool = false) {
        isFixed = fixed
    }
}

extension ArcKnobLayer : Adjustable {
    /**
     Create and return a new layer with adjusted arc width
     */
    public func arcWidth<F>(_ width:F) -> Self where F: BinaryFloatingPoint {
        setProperty { tmp in
            tmp.arcWidth = CGFloat(width)
        }
    }
    
    /**
     Create and return a new layer with adjusted arc color.
     
     To apply rich color on arc, refers to samples below:
     ```swift
     // Single color
     arcColor {
        Color.white
     }
     // Gradient colors
     arcColor {
        Color.red
        Color.blue
     }
     // Gradient colors represented by tuple -- rgba or rgba float.
     arcColor {
        (255, 0, 0, 255)
        (0.0, 0.0, 1.0, 1.0)
     }
     // Gradient colors with stops
     arcColor {
        Gradient.Stop(color: .red, location: 0.2)
        (Color.blue, location: 0.7) // a simplified represention of Gradient.Stop
     }
     ```
     
     - parameters:
        - builder: A GradientBuilder that build gradient from colors. It can accept Color, Gradient.Stop, and simplfied tuple representations.
     */
    public func arcColor(@GradientBuilder _ builder:()->Gradient) -> Self {
        setProperty { tmp in
            tmp.gradient = builder()
        }
    }
    
    /**
     Create and return a new layer with custom storke style.
     
     ArcKnobLayer allows developer to provide its own stroke style.
     Following example shows how to apply dash line on ArcKnobLayer
    ```swift
     ArcKnobLayer(fixed:true).arcWidth(5.0).arcColor {
         (Color.green, 0.6)
         (Color.yellow, 0.7)
         (Color.yellow, 0.9)
         (Color.red, 0.95)
     }.style(StrokeStyle(lineCap: .butt,
         lineJoin: .miter,
         miterLimit: 1.0,
         dash: [5.0,2.0],
         dashPhase: 1.0))
     ```
     - parameters:
        - style: The StrokeStyle apply on arc.  Note that the attribute *lineWidth* in StrokeStyle will be **ignored**. To adjust the width of arc layer, use *arcWidth* instead of.
     */
    public func style(_ style: StrokeStyle) -> Self {
        setProperty { tmp in
            tmp.style = style
        }
    }
}

@available(tvOS, unavailable)
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
                }.degree(degree).offset(dx: 0.0, dy: 20.0).radius(80.0).body.mask(Rectangle()).border(.white)
                
                ArcKnobLayer().arcWidth(5.0).arcColor {
                    (Color.green, 0.6)
                    (Color.yellow, 0.7)
                    (Color.yellow, 0.9)
                    (Color.red, 0.95)
                }.degree(degree).radius(80.0).body
                
                ArcKnobLayer(fixed:true).arcWidth(5.0).arcColor {
                    (Color.green, 0.6)
                    (Color.yellow, 0.7)
                    (Color.yellow, 0.9)
                    (Color.red, 0.95)
                }.style(StrokeStyle(lineCap: .butt, lineJoin: .miter, miterLimit: 1.0, dash: [5.0,2.0], dashPhase: 1.0)).arcWidth(30.0).degree(degree).body
            }.padding().border(.white)
            Slider(value: $degree, in: -225.0...45.0, label: {
                Text("Degree")
            }).padding()
        }
    }
}

struct ArcLayerPreview : PreviewProvider {
    static var previews: some View {
        #if os(tvOS)
        Text("No Preview Yet")
        #else
        ArcLayerDemo()
        #endif
    }
}
