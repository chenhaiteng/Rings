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

public let defaultRadius: CGFloat = 80.0

public let classicHourStyle: StrokeStyle = StrokeStyle(lineWidth: 5.0, lineCap: CGLineCap.butt, lineJoin: CGLineJoin.miter, miterLimit: 0.0, dash: [0, CGFloat.pi*100/6], dashPhase: 0.0)

public let classicMinStyle: StrokeStyle = StrokeStyle(lineWidth: 5.0, lineCap: CGLineCap.butt, lineJoin: CGLineJoin.miter, miterLimit: 0.0, dash: [0, CGFloat.pi*100/36], dashPhase: 0.0)

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
        StrokeStyle(lineWidth: self.lineWidth, lineCap: self.lineCap, lineJoin: self.lineJoin, miterLimit: self.miterLimit, dash: [0, CGFloat.pi*CGFloat(radius)/36], dashPhase: self.dashPhase)
    }
}

struct IndexStyle {
    var strokeStyle: StrokeStyle = StrokeStyle()
    var radius: CGFloat = 0.0
    var color: Color = .white
}


public struct ClockIndex: View {
    
    private var indexColor: Color = .black
    
    private var hourIndexStyle = IndexStyle(radius: defaultRadius + 15.0)

    private var minuteIndexStyle = IndexStyle(radius: defaultRadius + 10.0)
    
    private var hourGradient: AngularGradient = AngularGradient(colors: [.black], center: .center)
    private var minuteGradient: AngularGradient = AngularGradient(colors: [.black], center: .center, angle: Angle(degrees: 0.0))
    
    public init() {}
    
    public var body: some View {
        GeometryReader { geo in
            ZStack {
                if #available(iOS 15.0, macOS 12.0, watchOS 8.0, tvOS 15.0, *) {
                    Circle().stroke(style: minuteIndexStyle.strokeStyle).frame(width: 2*minuteIndexStyle.radius, height: 2*minuteIndexStyle.radius, alignment: .center).foregroundStyle(minuteGradient)
                } else {
                    Circle().stroke(style: minuteIndexStyle.strokeStyle).frame(width: 2*minuteIndexStyle.radius, height: 2*minuteIndexStyle.radius, alignment: .center).foregroundColor(minuteIndexStyle.color)
                }
                
                if #available(iOS 15.0, macOS 12.0, watchOS 8.0, tvOS 15.0, *) {
                    Circle().stroke(style: hourIndexStyle.strokeStyle).frame(width: 2*hourIndexStyle.radius, height: 2*hourIndexStyle.radius, alignment: .center).foregroundStyle(hourGradient)
                } else {
                    Circle().stroke(style: hourIndexStyle.strokeStyle).frame(width: 2*hourIndexStyle.radius, height: 2*hourIndexStyle.radius, alignment: .center).foregroundColor(hourIndexStyle.color)
                }
            }.frame(width: geo.size.width, height: geo.size.height, alignment: .center)
        }
    }
}

extension ClockIndex {
    func setProperty(_ setBlock: (_ clockIndex: inout Self) -> Void) -> Self {
        let result = _setProperty(content: self) { (tmp :inout Self) in
            setBlock(&tmp)
            return tmp
        }
        return result
    }
    
    public func hourIndex<T: BinaryFloatingPoint>(style: StrokeStyle? = nil, color: Color? = nil, radius: T? = nil) -> Self {
        setProperty { tmp in
            if let style = style {
                tmp.hourIndexStyle.strokeStyle = style
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
            }
            if let color = color {
                tmp.hourIndexStyle.color = color
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
            }
            if let color = color {
                tmp.minuteIndexStyle.color = color
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
}


//Previews
@available(tvOS, unavailable)
struct ClockIndexPreview_iPhone : View {
    @State var showIndex: Bool = true
    @State var hourRadius: CGFloat = 100
    @State var minRadius: CGFloat = 100
    @State var hourIndexWidth: CGFloat = 2
    @State var hourIndexHeight: CGFloat = 5
    @State var minIndexWidth: CGFloat = 1
    @State var minIndexHeight: CGFloat = 5
    
    var body: some View {
        VStack {
            Spacer(minLength: 10.0)
            Text("Clock Index")
            VStack {
                ClockIndex().minuteIndex(style:StrokeStyle.minuteStyle(markWidth: minIndexWidth, markHeight: minIndexHeight, radius: minRadius), color: .blue, radius: minRadius).hourIndex(style: StrokeStyle.hourStyle(markWidth: hourIndexWidth, markHeight: hourIndexHeight, radius: hourRadius), color: .red, radius: hourRadius)
                HStack {
                    Spacer(minLength: 5.0)
                    Text("Hour Index Style")
                    VStack {
                        Divider()
                    }
                }
                HStack(spacing: 10.0) {
                    Spacer()
                    VStack(alignment: .leading) {
                        HStack(spacing: 10.0) {
                            Text("width")
                            Slider(value:$hourIndexWidth, in: 2...5)
                            Text(String(format:"%.2f", hourIndexWidth))
                        }
                        HStack(spacing: 10.0) {
                            Text("height")
                            Slider(value:$hourIndexHeight, in: 0...15)
                            Text(String(format:"%.2f", hourIndexHeight))
                        }
                        HStack(spacing: 10.0) {
                            Text("radius")
                            Slider(value: $hourRadius, in: 60...120, step: 5.0)
                            Text(String(format: "%.2f", hourRadius))
                        }
                    }
                    Spacer()
                }
                HStack {
                    Spacer(minLength: 5.0)
                    Text("Minute Index Style")
                    VStack {
                        Divider()
                    }
                }
                HStack(spacing: 10.0) {
                    Spacer()
                    VStack(alignment: .leading) {
                        HStack(spacing: 10.0) {
                            Text("width")
                            Slider(value:$minIndexWidth, in: 1...5)
                            Text(String(format:"%.2f", minIndexWidth))
                        }
                        HStack(spacing: 10.0) {
                            Text("height")
                            Slider(value:$minIndexHeight, in: 1...10)
                            Text(String(format:"%.2f", minIndexHeight))
                        }
                        HStack {
                            Text("radius")
                            Slider(value: $minRadius, in: 60...120)
                            Text(String(format: "%.2f", minRadius))
                        }
                    }
                    Spacer()
                }
            }
            
        }
    }
}

@available(tvOS, unavailable)
struct ClockIndexPreview_MacOS : View {
    @State var showIndex: Bool = true
    @State var hourRadius: CGFloat = 80
    @State var minRadius: CGFloat = 80
    @State var hourIndexWidth: CGFloat = 2
    @State var hourIndexHeight: CGFloat = 5
    @State var minIndexWidth: CGFloat = 1
    @State var minIndexHeight: CGFloat = 5
    var body: some View {
        VStack {
            Spacer(minLength: 10.0)
            Text("Clock Index")
            VStack { ClockIndex().minuteIndex(style:StrokeStyle.minuteStyle(markWidth: minIndexWidth, markHeight: minIndexHeight, radius: minRadius), color: .blue).minuteIndex(radius: minRadius).hourIndex(style: StrokeStyle.hourStyle(markWidth: hourIndexWidth, markHeight: hourIndexHeight, radius: hourRadius), color: .red).hourIndex(radius: hourRadius).minuteIndexColor {
                Color.red
                Color.blue
                Color.yellow
            }.hourIndexColor {
                Color.yellow
                Color.red
                Color.blue
            }.frame(width: 200.0, height: 300.0)
                HStack {
                    Spacer()
                    Text("hour index style")
                    VStack {
                        Divider()
                    }
                }
                HStack(spacing: 10.0) {
                    Spacer()
                    VStack(alignment: .leading) {
                        HStack(spacing: 10.0) {
                            Text("w")
                            Slider(value:$hourIndexWidth, in: 2...5)
                            Text(String(format:"%.2f", hourIndexWidth))
                            Divider()
                            Text("h")
                            Slider(value:$hourIndexHeight, in: 0...15)
                            Text(String(format:"%.2f", hourIndexHeight))
                            Divider()
                            Text("r")
                            Slider(value: $hourRadius, in: 60...180)
                            Text(String(format: "%.2f", hourRadius))
                        }
                    }
                    Spacer()
                }
                HStack {
                    Spacer()
                    Text("minute index style")
                    VStack {
                        Divider()
                    }
                }
                HStack(spacing: 10.0) {
                    Spacer()
                    VStack(alignment: .leading) {
                        HStack(spacing: 10.0) {
                            Text("w")
                            Slider(value:$minIndexWidth, in: 1...5, step: 1.0)
                            Text(String(format:"%.2f", minIndexWidth))
                            Text("h")
                            Slider(value:$minIndexHeight, in: 1...5, step: 1.0)
                            Text(String(format:"%.2f", minIndexWidth))
                            Text("r")
                            Slider(value: $minRadius, in: 60...180)
                            Text(String(format: "%.2f", minRadius))
                        }
                    }
                    Spacer()
                }
                Spacer()
            }
            
        }
    }
}

struct ClockIndexPreview_Watch : View {
    @State var showIndex: Bool = true
    @State var hourIndexWidth: CGFloat = 2
    @State var hourIndexHeight: CGFloat = 5
    @State var minIndexWidth: CGFloat = 1
    @State var minIndexHeight: CGFloat = 5
    var body: some View {
        VStack {
            GeometryReader { geo in
                let watchRadius = min(geo.width, geo.height)/2.0
                ClockIndex().minuteIndex(style:StrokeStyle.minuteStyle(markWidth: minIndexWidth, markHeight: minIndexHeight, radius: watchRadius), color: .blue).minuteIndex(radius: watchRadius).hourIndex(style: StrokeStyle.hourStyle(markWidth: hourIndexWidth, markHeight: hourIndexHeight, radius: watchRadius), color: .red).hourIndex(radius: watchRadius).minuteIndexColor {
                    Color.red
                    Color.blue
                    Color.yellow
                }.hourIndexColor {
                    Color.yellow
                    Color.red
                    Color.blue
                }
            }
        }
    }
}

struct ClockIndex_Preview_tvOS : View {
    @State var hourRadius: CGFloat = 200
    @State var minRadius: CGFloat = 200
    @State var hourIndexWidth: CGFloat = 5
    @State var hourIndexHeight: CGFloat = 20
    @State var minIndexWidth: CGFloat = 5
    @State var minIndexHeight: CGFloat = 10
    
    var body: some View {
        VStack {
            VStack {
                ClockIndex().minuteIndex(style:StrokeStyle.minuteStyle(markWidth: minIndexWidth, markHeight: minIndexHeight, radius: minRadius), color: .blue, radius: minRadius).hourIndex(style: StrokeStyle.hourStyle(markWidth: hourIndexWidth, markHeight: hourIndexHeight, radius: hourRadius), color: .red, radius: hourRadius)
            }
            
        }
    }
}


struct ClockIndex_Previews: PreviewProvider {
    static var previews: some View {
#if os(iOS)
        ClockIndexPreview_iPhone().background(Color.white)
#endif
#if os(macOS)
        ClockIndexPreview_MacOS().background(Color.black).previewLayout(.sizeThatFits)
#endif
#if os(watchOS)
        ClockIndexPreview_Watch()
#endif
#if os(tvOS)
        ClockIndex_Preview_tvOS()
#endif
    }
}

