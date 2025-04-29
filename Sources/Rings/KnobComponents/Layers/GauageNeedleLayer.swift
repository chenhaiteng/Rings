//
//  GauageNeedleLayer.swift
//
//
//  Created by Chen Hai Teng on 2/1/24.
//

import SwiftUI
import Common
import CoreGraphics
import CoreGraphicsExtension
import SwiftClamping

@MainActor
public struct GauageNeedleLayer<V> : @preconcurrency AngularLayer where V: View {
    var content: () -> V
    public var isFixed: Bool = false
    private var blueprint: Bool = false
    
    @Clamping(0.0...0.0) public var degree: Double = 0.0
    public var degreeRange: ClosedRange<Double> {
        get {
            $degree
        }
        set {
            $degree = newValue
        }
    }
    
    @State private var contentSize: CGSize = .zero
    
    public var offset: CGPoint = .zero
    public var radius: CGFloat = 0.0
    public var center: UnitPoint
    
    public var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottom) {
                let geoCenter = geo.localCenter
                let polar = CGPolarPoint(radius: radius, angle: CGAngle.degrees(degree))
                let a = geoCenter.x - radius*(1.0 - 2.0*center.x)
                let anchor = CGPoint(x: a + offset.x, y: geo.height*center.y + offset.y)
                let adjustedCenter = geoCenter >> offset
                let pt = polar.cgpoint >> adjustedCenter
                let dx = pt.x - anchor.x
                let dy = pt.y - anchor.y
                let angular: CGAngle = CGVector.adjustedAtan2(y: dy, x: dx) + CGAngle.pi*0.5
                // blue print
                Path { coordinate in
                    coordinate.move(to: CGPoint(x: geoCenter.x - radius + offset.x, y:anchor.y))
                    coordinate.addLine(to: CGPoint(x: geoCenter.x + radius + offset.x, y:anchor.y))
                    coordinate.move(to: CGPoint(x: anchor.x, y: geoCenter.y - radius + offset.y))
                    coordinate.addLine(to: CGPoint(x: anchor.x, y:geoCenter.y + radius + offset.y))
                }.stroke(Color.blue.opacity(blueprint ? 0.7 : 0.0))
                Path { p in
                    p.move(to: anchor)
                    p.addLine(to: pt)
                }.stroke(Color.blue.opacity(blueprint ? 0.5 : 0.0), lineWidth: 10.0)
                Sizing {
                    content().frame(alignment: .bottom).if(!isFixed) { view in
                        view.rotationEffect(Angle.degrees(Double(angular.degrees)), anchor: .bottom)
                    }
                }.offset(x: (anchor.x - geoCenter.x) - contentSize.width/2.0, y: anchor.y - geo.height)
            }.onPreferenceChange(ViewSizeKey.self, perform: { value in
                if let v = value.first {
                    Task { @MainActor in
                        contentSize = v
                    }
                }
            })
        }
    }
    
    public init(fixed: Bool = false, center: UnitPoint = .center, @ViewBuilder _ builder: @escaping ()->V) {
        self.isFixed = fixed
        self.content = builder
        self.center = center
    }
}

extension GauageNeedleLayer : Adjustable {
    public func blueprint(_ show: Bool) -> Self {
        setProperty { adjustObject in
            adjustObject.blueprint = show
        }
    }
}

