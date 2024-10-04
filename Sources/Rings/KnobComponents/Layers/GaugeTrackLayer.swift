//
//  GaugeTrackLayer.swift
//
//
//  Created by Chen Hai Teng on 2/13/24.
//

import SwiftUI
import GradientBuilder

public struct GaugeTrackLayer : AngularLayer {
    public var radius: CGFloat
    
    public var offset: CGPoint
    
    public var degreeRange: ClosedRange<Double>
    
    public var degree: Double
    
    public var isFixed: Bool
    
    private var arcWidth: CGFloat
    private var gradient: Gradient
    private var style: StrokeStyle
    private var inset: CGFloat
    public var body: some View {
        ZStack {
            ArcKnobLayer(fixed: true).radius(radius).offset(dx: offset.x, dy: offset.y).arcWidth(arcWidth).arcGradient(gradient).style(style).inset(inset).degreeRange(degreeRange).body.opacity(0.5)
            ArcKnobLayer(fixed: false).radius(radius).offset(dx: offset.x, dy: offset.y).arcWidth(arcWidth).arcGradient(gradient).style(style).inset(inset).degreeRange(degreeRange).degree(degree).body
        }
    }
    public init(radius: CGFloat = 100.0,
                offset: CGPoint = .zero,
                degreeRange: ClosedRange<Double> = -180...0.0,
                degree: Double = -90.0,
                isFixed: Bool = true,
                arcWidth: CGFloat = 5.0,
                gradient: Gradient = Gradient(colors: [.white]),
                style: StrokeStyle = StrokeStyle(),
                inset: CGFloat = 0.0) {
        self.radius = radius
        self.offset = offset
        self.degreeRange = degreeRange
        self.degree = degree
        self.isFixed = isFixed
        self.arcWidth = arcWidth
        self.gradient = gradient
        self.style = style
        self.inset = inset
    }
}

extension GaugeTrackLayer : Adjustable {
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
    
    public func arcGradient(_ g: Gradient) -> Self {
        setProperty { adjustObject in
            adjustObject.gradient = g
        }
    }
    
    /**
     Create and return a new layer with custom storke style.
     
     ArcKnobLayer allows developer to provide its own stroke style.
     Following example shows how to apply dash line on ArcKnobLayer
    ```swift
     GaugeTrackLayer().arcWidth(5.0).arcColor {
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
    
    public func inset(_ value: CGFloat) -> Self {
        setProperty { adjustObject in
            adjustObject.inset = value
        }
    }
}
