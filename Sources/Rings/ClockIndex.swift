//
//  ClockIndex.swift
//  
//
//  Created by Chen Hai Teng on 4/22/21.
//

import SwiftUI
import CoreGraphicsExtension
import Common

public enum ClockIndexError: Error {
    case outOfBounds(String)
}

public let defaultTextMarker = ["1","2","3","4","5","6","7","8","9","10","11","12"]

public let defaultMarkers: [AnyView] = defaultTextMarker.map { num -> AnyView in
    AnyView(Text(num))
}

public let defaultRadius: CGFloat = 80.0

public let classicHourStyle: StrokeStyle = StrokeStyle(lineWidth: 5.0, lineCap: CGLineCap.butt, lineJoin: CGLineJoin.miter, miterLimit: 0.0, dash: [0, CGFloat.pi*100/6], dashPhase: 0.0)

public let classicMinStyle: StrokeStyle = StrokeStyle(lineWidth: 2.0, lineCap: CGLineCap.butt, lineJoin: CGLineJoin.miter, miterLimit: 0.0, dash: [0, CGFloat.pi*100/36], dashPhase: 0.0)

public extension StrokeStyle {
    func hourStyle<T: BinaryFloatingPoint>(with radius: T) -> Self {
        StrokeStyle(lineWidth: self.lineWidth, lineCap: self.lineCap, lineJoin: self.lineJoin, miterLimit: self.miterLimit, dash: [0, CGFloat.pi*CGFloat(radius)/6], dashPhase: self.dashPhase)
    }
    
    func minuteStyle<T: BinaryFloatingPoint>(with radius: T) -> Self {
        StrokeStyle(lineWidth: self.lineWidth, lineCap: self.lineCap, lineJoin: self.lineJoin, miterLimit: self.miterLimit, dash: [0, CGFloat.pi*CGFloat(radius)/36], dashPhase: self.dashPhase)
    }
}

public struct ClockIndex: View {
    
    private var hourMarkers: [AnyView] = defaultMarkers
    private var textColor: Color = .white
    private var radius: CGFloat = defaultRadius
    private var showBlueprint: Bool = false
    
    private var showIndex: Bool = true
    private var indexColor: Color = .white
    // hours index
    private var hourIndexStyle: StrokeStyle = StrokeStyle()
    private var hourIndexRadius: CGFloat = defaultRadius + 15.0
    private var hourIndexColor: Color = .white
    // minutes index
    private var minIndexStyle: StrokeStyle = StrokeStyle()
    private var minIndexRadius: CGFloat = defaultRadius + 10.0
    private var minIndexColor: Color = .white
    
    public init(textMarkers: [String] = defaultTextMarker, color: Color = .white) throws {
        guard textMarkers.count == 12 else {
            throw ClockIndexError.outOfBounds("The number of markers whould be 12.")
        }
        textColor = color
        hourMarkers = textMarkers.map({ text -> AnyView in
            AnyView(Text(text).foregroundColor(textColor))
        })
    }
    
    public init(_ markers: [AnyView]) throws {
        guard markers.count == 12 else {
            throw ClockIndexError.outOfBounds("The number of markers whould be 12.")
        }
        hourMarkers = markers
    }
    
    public var body: some View {
        GeometryReader { geo in
            ZStack {
                if(showIndex) {
                    Circle().stroke(style: hourIndexStyle).frame(width: 2*hourIndexRadius, height: 2*hourIndexRadius, alignment: .center).foregroundColor(hourIndexColor)
                    Circle().stroke(style: minIndexStyle).frame(width: 2*minIndexRadius, height: 2*minIndexRadius, alignment: .center).foregroundColor(minIndexColor)
                }
                ForEach(0..<12) { index in
                    let polarPt = CGPolarPoint(radius: radius, angle: CGAngle.pi/6*CGFloat(index) - CGAngle.pi/3)
                    Sizing {
                        hourMarkers[index].if(showBlueprint) { content in
                            content.border(Color.blue, width: 1)
                        }
                    }.offset(x: polarPt.cgpoint.x, y: polarPt.cgpoint.y)
                }
                if(showBlueprint) {
                    Path { path in
                        path.addEllipse(in: CGRect(origin: CGPoint(x: geo.size.width/2 - radius, y: geo.size.height/2 - radius), size: CGSize(width: 2*radius, height: 2*radius)), transform: CGAffineTransform.identity)
                    }.stroke(Color.blue, lineWidth: 1.0)
                }
            }.frame(width: geo.size.width, height: geo.size.height, alignment: .center).if(showBlueprint){ content in
                content.border(Color.blue, width: 1)
            }
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
    
    public func radius<T: BinaryFloatingPoint>(_ r: T) -> Self {
        setProperty { tmp in
            tmp.radius = CGFloat(r)
        }
    }
    public func showBlueprint(_ show: Bool) -> Self {
        setProperty { tmp in
            tmp.showBlueprint = show
        }
    }
    
    public func hourIndexStyle(_ style: StrokeStyle, color: Color? = nil) -> Self {
        setProperty { tmp in
            tmp.hourIndexStyle = style
            tmp.hourIndexColor = color ?? tmp.hourIndexColor
        }
    }
    
    public func hourIndexRadius<T: BinaryFloatingPoint>(_ r: T) -> Self {
        setProperty { tmp in
            tmp.hourIndexRadius = CGFloat(r)
        }
    }
    
    public func minIndexStyle(_ style: StrokeStyle, color: Color? = nil) -> Self {
        setProperty { tmp in
            tmp.minIndexStyle = style
            tmp.minIndexColor = color ?? tmp.minIndexColor
        }
    }
    
    public func minIndexRadius<T: BinaryFloatingPoint>(_ r: T) -> Self {
        setProperty { tmp in
            tmp.minIndexRadius = CGFloat(r)
        }
    }
    
    public func showIndex(_ show: Bool = true) -> Self {
        setProperty { tmp in
            tmp.showIndex = show
        }
    }
}

//Previews
struct ClockPreviewClassic : View {
    @State var showBlueprint: Bool = false
    @State var showIndex: Bool = true
    @State var indexRadius: CGFloat = 60
    @State var indexRadius2: CGFloat = 100
    var body: some View {
        VStack {
            Spacer(minLength: 10.0)
            Text("Classic Clocks")
            HStack {
                VStack {
                    try? ClockIndex().radius(50.0).showBlueprint(showBlueprint).hourIndexStyle(StrokeStyle(lineWidth: 5.0).hourStyle(with: indexRadius)).hourIndexRadius(indexRadius)
                        .minIndexStyle(StrokeStyle().minuteStyle(with: indexRadius)).minIndexRadius(indexRadius)
                        .showIndex(showIndex)
                    HStack {
                        Slider(value: $indexRadius, in: 30...100, step: 5.0)
                        Text("\(indexRadius)")
                    }
                }
                VStack {
                    try? ClockIndex(textMarkers: ["I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX", "X", "XI", "XII"]).showBlueprint(showBlueprint).hourIndexStyle(StrokeStyle(lineWidth: 5.0).hourStyle(with: indexRadius2+5), color: .red).hourIndexRadius(indexRadius2+5)
                        .minIndexStyle(StrokeStyle().minuteStyle(with: indexRadius2-5), color: .blue).minIndexRadius(indexRadius2-5)
                        .showIndex(showIndex)
                    HStack {
                        Slider(value: $indexRadius2, in: 60...150, step: 5.0)
                        Text("\(indexRadius2)")
                    }
                }
            }
            Toggle("Show Index", isOn: $showIndex)
            Spacer(minLength: 5.0)
            Divider()
            Toggle("Blue Print", isOn: $showBlueprint)
            Spacer(minLength: 10.0)
        }
    }
}

struct ClockPreviewEarthlyBranches : View {
    @State var showBlueprint: Bool = false
    var body: some View {
        VStack {
            Spacer(minLength: 10.0)
            Text("Earchly Branches Clocks")
            HStack {
                try? ClockIndex(textMarkers: ["．", "丑", "．", "寅", "．", "卯", "．", "辰", "．", "巳", "．", "子"], color: .red).showBlueprint(showBlueprint)
                
                try? ClockIndex(textMarkers: ["．", "未", "．", "申", "．", "酉", "．", "戌", "．", "亥", "．", "午"]).showBlueprint(showBlueprint)
            }
            Toggle("Blue Print", isOn: $showBlueprint)
            Spacer(minLength: 10.0)
        }
    }
}

struct ClockIndex_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ClockPreviewClassic()
        }
        Group {
            ClockPreviewEarthlyBranches()
        }
    }
}

