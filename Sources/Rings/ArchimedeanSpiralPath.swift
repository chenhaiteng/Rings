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
    
    public init(_ innerRadius: Double = 12.0, spacing: Double = 10.0, gap: Double = 5.0, count: Int = 100) {
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
    public func start(_ angle: CGAngle) -> Self {
        setProperty { tmp in
            tmp.startAngle = angle
        }
    }
}
