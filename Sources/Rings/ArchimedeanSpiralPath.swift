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

@available(tvOS, unavailable)
struct ArchimedeanSpiralPath_Preview : View {
    @State var radiusSpacing: Double = 10.0
    @State var innerR: Double = 5.0
    @State var spacing: Double = 25.0
    @State var count: Double = 100.0
    @State var startAt: Double = 0.0
    var body: some View {
        VStack {
            ArchimedeanSpiralPath(innerR, spacing: radiusSpacing, gap: spacing, count: Int(count)).start(CGAngle.degrees(startAt))
            Divider()
            ScrollView {
                HStack {
                    Text("start at")
                    Slider(value: $startAt, in: 0.0...360.0)
                    Text("\(String(format: "%.2f", startAt))")
                }
                HStack {
                    Text("radius spacing")
                    Slider(value: $radiusSpacing, in: 10.0...50.0)
                    Text("\(String(format: "%.2f", radiusSpacing))")
                }
                HStack {
                    Text("inner radius")
                    Slider(value: $innerR, in: 10.0...50.0)
                    Text("\(String(format: "%.2f", innerR))")
                }
                HStack {
                    Text("points spacing")
                    Slider(value: $spacing, in: 10.0...50.0)
                    Text("\(String(format: "%.2f", spacing))")
                }
                HStack {
                    
                    Text("node count")
                    Slider(value: $count, in: 100.0...200.0, step: 10.0)
                    Text("\(String(format: "%d", Int(count)))")
                }
            }
        }.padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
    }
}

#if os(tvOS)
struct ArchimedeanSpiralPath_Preview_tvOS : View {
    @State var radiusSpacing: Double = 50.0
    @State var innerR: Double = 10.0
    @State var spacing: Double = 30.0
    @State var count: Double = 100.0
    @State var startAt: Double = 0.0
    var body: some View {
        VStack {
            ZStack {
                GeometryReader { geo in
                    ArchimedeanSpiralPath(innerR, spacing: radiusSpacing, gap: spacing, count: Int(count)).start(CGAngle.degrees(startAt))
                }
            }
        }
    }
}

#endif

struct ArchimedeanSpiralPath_Previews: PreviewProvider {
    static var previews: some View {
#if os(tvOS)
        ArchimedeanSpiralPath_Preview_tvOS()
#else
        ArchimedeanSpiralPath_Preview()
#endif
    }
}
