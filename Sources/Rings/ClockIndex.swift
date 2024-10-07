//
//  ClockIndex.swift
//  
//
//  Created by Chen Hai Teng on 4/22/21.
//

import SwiftUI
import CoreGraphicsExtension
import Common
import GradientBuilder

public enum ClockIndexError: Error {
    case outOfBounds(String)
}

/// clock index default radius 80.0
public let defaultRadius: CGFloat = 80.0

public extension StrokeStyle {
    static func hourStyle<T: BinaryFloatingPoint>(markWidth: T, markHeight: T, radius: T) -> Self {
        StrokeStyle(lineWidth: CGFloat(markHeight), lineCap: .butt, lineJoin: .miter, miterLimit: 10.0, dash:
                        [CGFloat(markWidth), CGFloat.pi*CGFloat(radius)/6 - CGFloat(markWidth)], dashPhase: CGFloat(markWidth)/2.0)
    }
    
    static func minuteStyle<T: BinaryFloatingPoint>(markWidth: T, markHeight: T, radius: T) -> Self {
        StrokeStyle(lineWidth: CGFloat(markHeight), lineCap: .butt, lineJoin: .miter, miterLimit: 10.0, dash:
                        [CGFloat(markWidth), CGFloat.pi*CGFloat(radius)/36 - CGFloat(markWidth)], dashPhase: CGFloat(markWidth)/2.0)
    }
    
    func minuteStyle<T: BinaryFloatingPoint>(with radius: T) -> Self {
        StrokeStyle(lineWidth: self.lineWidth, lineCap: self.lineCap, lineJoin: self.lineJoin, miterLimit: self.miterLimit, dash: [self.dash.first ?? 0.0, CGFloat.pi*CGFloat(radius)/36 - (self.dash.first ?? 0.0)], dashPhase: self.dashPhase)
    }
}

struct IndexStyle {
    var strokeStyle: StrokeStyle = StrokeStyle()
    var radius: CGFloat = 0.0
    var color: Color = .white
    var markSize: CGSize = .init(width: 1.0, height: 2.0)
}

/// A convenient view that composite clock index shape
@available(*, deprecated, message: "deprecated at version 0.5.0, use ClockIndexShape instead of.")
public struct ClockIndex: View {
    
    private var hourIndexStyle = IndexStyle(radius: defaultRadius)

    private var minuteIndexStyle = IndexStyle(radius: defaultRadius)
    
    private var hourGradient: AngularGradient = AngularGradient(colors: [.black], center: .center)
    private var minuteGradient: AngularGradient = AngularGradient(colors: [.black], center: .center, angle: Angle(degrees: 0.0))
    
    /// Create a default clock index with radius ``defaultRadius``
    public init() {}
    
    public var body: some View {
        GeometryReader { geo in
            ZStack {
                ClockIndexShape.minuteIndexShape(markSize: minuteIndexStyle.markSize).fill(minuteGradient).frame(width: 2*minuteIndexStyle.radius, height: 2*minuteIndexStyle.radius)
                ClockIndexShape.hourIndexShape(markSize: hourIndexStyle.markSize).fill(hourGradient).frame(width: 2*hourIndexStyle.radius, height: 2*hourIndexStyle.radius)
            }.frame(width: geo.size.width, height: geo.size.height, alignment: .center)
        }
    }
}

extension ClockIndex : Adjustable {
    public func hourIndex<T: BinaryFloatingPoint>(style: StrokeStyle? = nil, color: Color? = nil, radius: T? = nil) -> Self {
        setProperty { tmp in
            if let style = style {
                tmp.hourIndexStyle.strokeStyle = style
                tmp.hourIndexStyle.markSize = CGSize(width: style.dash.first ?? 1.0, height: style.lineWidth)
            }
            if let color = color {
                tmp.hourIndexStyle.color = color
                tmp.hourGradient = AngularGradient(colors: [color], center: .center)
            }
            if let radius = radius as? CGFloat {
                tmp.hourIndexStyle.radius = radius
            }
        }
    }
    
    public func hourIndex(style: StrokeStyle? = nil, color: Color? = nil) -> Self {
        setProperty { tmp in
            if let style = style {
                tmp.hourIndexStyle.strokeStyle = style
                tmp.hourIndexStyle.markSize = CGSize(width: style.dash.first ?? 2.0, height: style.lineWidth)
            }
            if let color = color {
                tmp.hourIndexStyle.color = color
                tmp.hourGradient = AngularGradient(colors: [color], center: .center)

            }
        }
    }
    
    @available(*, deprecated, renamed: "hourIndex(style:color:)", message: "deprecated at version 0.4.0")
    public func hourIndexStyle(_ style: StrokeStyle, color: Color? = nil) -> Self {
        setProperty { tmp in
            tmp.hourIndexStyle.strokeStyle = style
            tmp.hourIndexStyle.color = color ?? tmp.hourIndexStyle.color
        }
    }
    
    @available(*, deprecated, renamed: "hourIndex(style:color:radius:)", message: "deprecated at version 0.4.0")
    public func hourIndexRadius<T: BinaryFloatingPoint>(_ r: T) -> Self {
        setProperty { tmp in
            tmp.hourIndexStyle.radius = CGFloat(r)
        }
    }
    
    public func minuteIndex<T: BinaryFloatingPoint>(style: StrokeStyle? = nil, color: Color? = nil, radius: T? = nil) -> Self {
        setProperty { tmp in
            if let style = style {
                tmp.minuteIndexStyle.strokeStyle = style
                tmp.minuteIndexStyle.markSize = CGSize(width: style.dash.first ?? 1.0, height: style.lineWidth)
            }
            if let color = color {
                tmp.minuteIndexStyle.color = color
                tmp.minuteGradient = AngularGradient(colors: [color], center: .center)
            }
            if let radius = radius as? CGFloat {
                tmp.minuteIndexStyle.radius = radius
            }
        }
    }
    
    public func minuteIndex(style: StrokeStyle? = nil, color: Color? = nil) -> Self {
        setProperty { tmp in
            if let style = style {
                tmp.minuteIndexStyle.strokeStyle = style
                tmp.minuteIndexStyle.markSize = CGSize(width: style.dash.first ?? 1.0, height: style.lineWidth)
            }
            if let color = color {
                tmp.minuteIndexStyle.color = color
                tmp.minuteGradient = AngularGradient(colors: [color], center: .center)
            }
        }
    }
    
    @available(*, deprecated, renamed: "minuteIndex(style:color:)", message: "deprecated at version 0.4.0")
    public func minIndexStyle(_ style: StrokeStyle, color: Color? = nil) -> Self {
        setProperty { tmp in
            tmp.minuteIndexStyle.strokeStyle = style
            tmp.minuteIndexStyle.color = color ?? tmp.minuteIndexStyle.color
        }
    }
    
    @available(*, deprecated, renamed: "minuteIndex(style:color:radius:)", message: "deprecated at version 0.4.0")
    public func minIndexRadius<T: BinaryFloatingPoint>(_ r: T) -> Self {
        setProperty { tmp in
            tmp.minuteIndexStyle.radius = CGFloat(r)
        }
    }
    
    public func minuteIndexColor(@GradientBuilder colors: () -> Gradient) -> Self {
        setProperty { clockIndex in
            if #available(iOS 15.0, macOS 12.0, *) {
                clockIndex.minuteGradient = AngularGradient(gradient: colors(), center: .center)
            } else {
                clockIndex.minuteIndexStyle.color = colors().stops[0].color
            }
        }
    }
    
    public func hourIndexColor(@GradientBuilder colors: () -> Gradient) -> Self {
        setProperty { clockIndex in
            if #available(iOS 15.0, macOS 12.0, *) {
                clockIndex.hourGradient = AngularGradient(gradient: colors(), center: .center)
            } else {
                clockIndex.hourIndexStyle.color = colors().stops[0].color
            }
        }
    }
    
    public func minuteIndex(markSize: CGSize) -> Self {
        setProperty { adjustObject in
            let oldStyle = minuteIndexStyle.strokeStyle
            adjustObject.minuteIndexStyle.strokeStyle = StrokeStyle(lineWidth: markSize.height, lineCap: oldStyle.lineCap, lineJoin: oldStyle.lineJoin, miterLimit: oldStyle.miterLimit, dash:[CGFloat(markSize.width), CGFloat.pi*CGFloat(minuteIndexStyle.radius)/36 - CGFloat(markSize.width)], dashPhase: CGFloat(markSize.width)/2.0)
            adjustObject.minuteIndexStyle.markSize = markSize
        }
    }
    
    public func hourIndex(markSize: CGSize) -> Self {
        setProperty { adjustObject in
            let oldStyle = hourIndexStyle.strokeStyle
            adjustObject.hourIndexStyle.strokeStyle = StrokeStyle(lineWidth: markSize.height, lineCap: oldStyle.lineCap, lineJoin: oldStyle.lineJoin, miterLimit: oldStyle.miterLimit, dash:[CGFloat(markSize.width), CGFloat.pi*CGFloat(hourIndexStyle.radius)/6 - CGFloat(markSize.width)], dashPhase: CGFloat(markSize.width)/2.0)
            adjustObject.hourIndexStyle.markSize = markSize
        }
    }
}
