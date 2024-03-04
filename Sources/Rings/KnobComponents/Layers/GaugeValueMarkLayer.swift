//
//  GaugeValueMarkLayer.swift
//
//
//  Created by Chen Hai Teng on 2/1/24.
//

import SwiftUI
import Common
import CoreGraphicsExtension
import SwiftClamping

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
    private var inset: CGFloat = 0.0
    private var markLength: CGFloat = 5.0
    private let markBuilder: ()->V
    
    public var body: some View {
        get {
            ZStack {
                GeometryReader { geo in
                    let polar = CGPolarPoint(radius: radius - inset, angle: CGAngle.degrees(degree))
                    let point = (polar.cgpoint >> geo.localCenter) >> offset
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

extension GaugeValueMarkLayer : Adjustable {
    func inset(_ value: CGFloat) -> Self {
        setProperty { adjustObject in
            adjustObject.inset = value
        }
    }
}

