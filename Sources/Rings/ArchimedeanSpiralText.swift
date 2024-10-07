//
//  ArchimedeanSpiralText.swift
//  Rings
//
//  Created by Chen Hai Teng on 3/5/21.
//

import SwiftUI
import ArchimedeanSpiral
import CoreGraphicsExtension
import Common

@available(*, deprecated, renamed: "RingLayoutDirection", message: "deprectaed at version 0.4.0")
public enum TextDirection {
    case Top, Bottom, Left, Right
    var cgangle: CGAngle {
        switch self {
        case .Top:
            return CGAngle.degrees(270.0)
        case .Bottom:
            return CGAngle.degrees(90.0)
        case .Left:
            return CGAngle.degrees(0.0)
        case .Right:
            return CGAngle.degrees(180.0)
        }
    }
}

@available(*, deprecated, renamed: "RingLayoutDirection", message: "deprectaed at version 0.4.0")
extension TextDirection {
    var ringLayoutDirection : RingLayoutDirection {
        switch self {
        case .Top:
            RingLayoutDirection.toCenter
        case .Bottom:
            RingLayoutDirection.fromCenter
        case .Left:
            RingLayoutDirection.alongCounterClockwise
        case .Right:
            RingLayoutDirection.alongClockwise
        }
    }
}

/// A view that displays read-only text along archimedean spiral.
public struct ArchimedeanSpiralText: View, CompatibleForegroundProxy {
    public typealias Content = Self
    
    private var radiusSpacing: Double
    private var innerRadius: Double
    private var gap: Double
    private var textDirection: RingLayoutDirection = .fromCenter
    private var font = Font.system(size: 20.0)
    public var color: Color
    public var style: any ShapeStyle
    
    private var text: String {
        didSet {
            chars = Array(text.enumerated())
        }
    }
    
    private var chars: [(offset: Int, element:Character)] {
        didSet {
            
        }
    }
    
    private var textPoints: [CGPolarPoint] = []
    
    /// Creates a archimedean spiral text.
    /// - Parameters:
    ///   - innerRadius: the distance between the center and the innerest char.
    ///   - radiusSpacing: the distance between each radius at the same phase.
    ///   - gap: specifies the distance between adjacent charcters.
    ///   - text: the text displayed.
    public init(_ innerRadius: Double = 12.0, radiusSpacing: Double = 10.0, gap: Double = 5.0, text: String = "") {
        self.radiusSpacing = radiusSpacing
        self.innerRadius = innerRadius
        self.gap = gap
        self.text = text
        self.chars = Array(text.enumerated())
        self.color = .white
        self.style = .white
        updateTextPoints()
    }
    
    private mutating func updateTextPoints() {
        let spiral = ArchimedeanSpiral(innerRadius: self.innerRadius, radiusSpacing: self.radiusSpacing, spacing: self.gap)
        textPoints = spiral.equidistantPoints(start: CGAngle.zero, num: self.chars.count)
    }
    
    public var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(chars, id: \.self.offset) { (offset, element) in
                    let pt = self.textPoints[offset].cgpoint
                    let textPt = CGPoint(x: pt.x, y: pt.y)
                    let rotation = textDirection.cgangle(with: self.textPoints[offset].cgangle).toAngle()
                    Text(String(element))
                        .compatibleForeground(self)
                        .rotationEffect(rotation)
                        .offset(x: textPt.x, y: textPt.y)
                        .font(font)
                }
            }.frame(width: geo.size.width, height: geo.size.height, alignment: .center)
        }
    }
}

extension ArchimedeanSpiralText: Adjustable {
    /// Sets the space between adjacent points at the same phase.
    /// - Parameter space: The distance between adjacent points at the same phase.
    /// - Returns: Archimedean spiral text use the space you specify.
    public func radiusSpacing<T: BinaryFloatingPoint>(_ space: T) -> Self {
        setProperty { tmp in
            tmp.radiusSpacing = Double(space)
            tmp.updateTextPoints()
        }
    }
    
    /// Sets the space between the first character and the center
    /// - Parameter radius: The radius of the first character.
    /// - Returns: Archimedean spiral text use the inner radius you specify.
    public func innerRadius<T: BinaryFloatingPoint>(_ radius: T) -> Self {
        setProperty { tmp in
            tmp.innerRadius = Double(radius)
            tmp.updateTextPoints()
        }
    }
    
    /// Sets the gap between the
    /// - Parameter gap: The gap between adjacent characters.
    /// - Returns: Archimedean spiral text use the gap you specify.
    public func gap<T: BinaryFloatingPoint>(_ gap: T) -> Self {
        setProperty { tmp in
            tmp.gap = Double(gap)
            tmp.updateTextPoints()
        }
    }
    
    @available(*, deprecated, renamed: "textLayoutDirection", message: "deprectaed at version 0.4.0")
    /// Sets how to layout each character along the archimedean spiral.
    /// - Parameter direction: Text direction
    /// - Returns: Archimedean spiral text use the text direction you specify.
    public func textDirection(_ direction: TextDirection) -> Self {
        setProperty { tmp in
            tmp.textDirection = direction.ringLayoutDirection
        }
    }
    
    /// Sets how to layout each character along the archimedean spiral.
    /// - Parameter direction: The layout direction which depends on the top of each character.
    /// - Returns: Archimedean spiral text use the layout direction you specify.
    public func textLayoutDirection(_ direction: RingLayoutDirection) -> Self {
        setProperty { tmp in
            tmp.textDirection = direction
        }
    }
    
    /// Sets the font for text in the view
    /// - Parameter font: The font to use when displaying this text.
    /// - Returns: Archimedean spiral text use the font you specify.
    public func font(_ font: Font) -> Self {
        setProperty { tmp in
            tmp.font = font
        }
    }
    
    /// Sets the color for text in the view
    /// - Parameter font: The color to use when displaying this text.
    /// - Returns: Archimedean spiral text use the color you specify.
    public func textColor(_ color: Color) -> Self {
        setProperty { tmp in
            tmp.color = color
            tmp.style = color
        }
    }
}
