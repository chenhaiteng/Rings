//
//  ArchimedeanSpiralPath.swift
//  Rings
//
//  Created by Chen Hai Teng on 3/5/21.
//

import SwiftUI
import ArchimedeanSpiral
import CoreGraphicsExtension

public struct ArchimedeanSpiralPath: View {
    var radiusSpacing: Double
    var innerRadius: Double
    var gap: Double
    var ptCount: Int
    var spiralDesc :ArchimedeanSpiral
    var startAngle: CGAngle = CGAngle.zero
    
    private lazy var points: [CGPoint] = spiralDesc.equidistantPoints(start: startAngle, num: ptCount).map { polar in
        polar.cgpoint
    }
    
    init(_ innerRadius: Double = 12.0, spacing: Double = 10.0, gap: Double = 5.0, count: Int = 100) {
        self.radiusSpacing = spacing
        self.innerRadius = innerRadius
        self.gap = gap
        self.ptCount = count
        spiralDesc = ArchimedeanSpiral(innerRadius: self.innerRadius, radiusSpacing: self.radiusSpacing, spacing: self.gap)
        
    }
    
    func getPoints()-> [CGPoint] {
        var mutateSelf = self
        return mutateSelf.points
    }
    
    public var body: some View {
        GeometryReader { geo in
            Path { path in
                let midX = geo.size.width/2
                let midY = geo.size.height/2
                path.move(to: CGPoint(
                    x: midX,
                    y: midY
                ))
                getPoints().forEach { pt in
                    let next = CGPoint(x: pt.x + midX, y: pt.y + midY)
                    path.addLine(to: next)
                }
            }.stroke(Color.red)
        }
    }
}

extension ArchimedeanSpiralPath : Adjustable {
    func start(_ angle: CGAngle) -> Self {
        setProperty { tmp in
            tmp.startAngle = angle
        }
    }
}

struct ArchimedeanSpiralPathDemo : View {
    @State var radiusSpacing: Double = 10.0
    @State var innerR: Double = 5.0
    @State var spacing: Double = 25.0
    @State var count: Double = 100.0
    @State var startAt: Double = 0.0
    @State var showInner: Bool = false
    @State var showRadius: Bool = false
    var body: some View {
        VStack {
            ZStack {
                GeometryReader { geo in
                    let midX = geo.size.width/2
                    let midY = geo.size.height/2
                    ArchimedeanSpiralPath(innerR, spacing: radiusSpacing, gap: spacing, count: Int(count)).start(CGAngle.degrees(startAt))
                    Group {
                        if (showInner) {
                            Path { p in
                                p.move(to: CGPoint(x: midX, y: midY))
                                p.addLine(to: CGPoint(x: midX + CGFloat(innerR), y: midY))
                            }.stroke(style: StrokeStyle(lineWidth: 2.0, lineCap: .butt, lineJoin: .miter, miterLimit: 0, dash: [3,1], dashPhase: 0))
                        }
                        if(showRadius) {
                            Path { p in
                                p.move(to: CGPoint(x: midX + CGFloat(innerR), y: midY))
                                p.addLine(to: CGPoint(x: midX + CGFloat(innerR) + CGFloat(radiusSpacing), y: midY))
                            }.stroke(Color.blue, style: StrokeStyle(lineWidth: 2.0, lineCap: .butt, lineJoin: .miter, miterLimit: 0, dash: [3,1], dashPhase: 0))
                        }
                    }
                }
            }
            Slider(value: $startAt, in: 0.0...360.0) {
                Text("start at (\(startAt))")
            }.padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
            Slider(value: $radiusSpacing, in: 10.0...50.0) {
                Toggle("", isOn: $showRadius)
                Text("radius spacing (\(radiusSpacing))")
            }.padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
            Slider(value: $innerR, in: 10.0...50.0) {
                Toggle("", isOn: $showInner)
                Text("inner radius(\(innerR))")
            }.padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
            Slider(value: $spacing, in: 10.0...50.0) {
                Text("points spacing(\(spacing))")
            }.padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
            Slider(value: $count, in: 100.0...200.0, step: 10.0) {
                Text("count(\(Int(count)))")
            }.padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        ArchimedeanSpiralPathDemo()
    }
}
