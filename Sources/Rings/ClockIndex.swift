//
//  ClockIndex.swift
//  
//
//  Created by Chen Hai Teng on 4/22/21.
//

import SwiftUI
import CoreGraphicsExtension
import CommonExts

public enum ClockIndexError: Error {
    case outOfBounds(String)
}

public let defaultTextMarker = ["1","2","3","4","5","6","7","8","9","10","11","12"]

public let defaultMarkers: [AnyView] = defaultTextMarker.map { num -> AnyView in
    AnyView(Text(num))
}

public let defaultRadius: CGFloat = 80.0

public struct ClockIndex<Surface: View>: View {
    
    private var hourMarkers: [AnyView] = defaultMarkers
    private var radius: CGFloat = defaultRadius
    private var showBlueprint: Bool = false
    
    public init(textMarkers: [String] = defaultTextMarker, surface: Surface? = nil) throws {
        guard textMarkers.count == 12 else {
            throw ClockIndexError.outOfBounds("The number of markers whould be 12.")
        }
        hourMarkers = textMarkers.map({ text -> AnyView in
            AnyView(Text(text))
        })
    }
    
    public init(_ markers: [AnyView], surface: Surface? = nil) throws {
        guard markers.count == 12 else {
            throw ClockIndexError.outOfBounds("The number of markers whould be 12.")
        }
        hourMarkers = markers
    }
    
    public var body: some View {
        GeometryReader { geo in
            ZStack {
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
    
    public func radius(_ r: CGFloat) -> Self {
        setProperty { tmp in
            tmp.radius = r
        }
    }
    public func showBlueprint(_ show: Bool) -> Self {
        setProperty { tmp in
            tmp.showBlueprint = show
        }
    }
}

//Previews
struct ClockPreviewClassic : View {
    @State var showBlueprint: Bool = false
    var body: some View {
        VStack {
            Spacer(minLength: 10.0)
            Text("Classic Clocks")
            HStack {
                try? ClockIndex<Text>().radius(50.0).showBlueprint(showBlueprint)
                try? ClockIndex<Text>(textMarkers: ["I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX", "X", "XI", "XII"]).showBlueprint(showBlueprint)
            }
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
                try? ClockIndex<Text>(textMarkers: ["．", "丑", "．", "寅", "．", "卯", "．", "辰", "．", "巳", "．", "子"]).showBlueprint(showBlueprint)
                
                try? ClockIndex<Text>(textMarkers: ["．", "未", "．", "申", "．", "酉", "．", "戌", "．", "亥", "．", "午"]).showBlueprint(showBlueprint)
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

