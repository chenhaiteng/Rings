//
//  GaugeValueMarkLayer.swift
//
//
//  Created by Chen Hai Teng on 2/1/24.
//

import SwiftUI
import Common
import CoreGraphicsExtension

struct GaugeValueMarkLayer<V> : AngularLayer where V : View {
    public var isFixed = false
    
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
    
    private var markLength: CGFloat = 5.0
    private let markBuilder: ()->V
    
    public var body: some View {
        get {
            ZStack {
                GeometryReader { geo in
                    let radius = min(geo.size.height, geo.size.width)/2.0
                    let polar = CGPolarPoint(radius: radius, angle: CGAngle.degrees(degree))
                    let point = polar.cgpoint.offset(dx: geo.size.width/2.0 + offset.x, dy: geo.size.height/2.0 + offset.y)
                    markBuilder().frame(width: markLength, height: markLength).rotationEffect(Angle(degrees: degree + 90.0))
                        .offset(x: point.x - markLength/2.0, y: point.y - markLength/2.0)
                }
            }
        }
    }
    
    public init(_ markLength:CGFloat = 10.0, @ViewBuilder _ builder: @escaping () -> V) {
        self.markLength = markLength
        self.markBuilder = builder
    }
}
