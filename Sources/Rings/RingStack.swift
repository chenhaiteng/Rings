//
//  RingStack.swift
//
//
//  Created by Chen Hai Teng on 10/19/23.
//

import SwiftUI
import CoreGraphicsExtension

@available(iOS, introduced: 14.0, deprecated: 16.0, renamed: "RingStack")
@MainActor public struct RingList<Content>: View  where Content : View {

    private var content: Content
    private var radius: CGFloat = 100.0
    private var phase: Angle = .zero
    
    public var body: some View {
        ZStack {
            content.variadic { children in
                ForEach(0..<children.endIndex, id: \.self) { index in
                    let polarPt = CGPolarPoint(radius: radius, angle: CGAngle.pi*CGFloat(index)*2/CGFloat(children.endIndex) + CGFloat(phase.radians))
                    children[index].offset(x: polarPt.cgpoint.x, y: polarPt.cgpoint.y)
                    
                }
            }
        }
    }
    
    @MainActor public init(radius: CGFloat = 100.0, phase: Angle = .zero, @ViewBuilder content: () -> Content) {
        self.radius = radius
        self.phase = phase
        self.content = content()
    }
}

// https://swiftui-lab.com/layout-protocol-part-1/
@available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, *)
struct _RingStack : Layout {
    struct RotationValue : LayoutValueKey {
        static let defaultValue: Binding<Angle>? = nil
    }
    
    struct CacheData {
        var extraSize: CGFloat
        var baseAngle: Angle
    }
    
    private var radius: CGFloat
    private var phase: Angle
    private var center: UnitPoint
    private var direction: RingLayoutDirection
    private let trace: String
    
    var animatableData: AnimatablePair<Double, CGFloat> {
        get {
            AnimatablePair(phase.radians, radius)
        }
        set {
            phase = Angle(radians:newValue.first)
            radius = newValue.second
        }
    }
    
    func makeCache(subviews: Subviews) -> CacheData {
        let maxSubViewWidth = subviews.max {
            $0.sizeThatFits(.unspecified).width < $1.sizeThatFits(.unspecified).width
        }?.sizeThatFits(.unspecified).width ?? 0.0
        let maxSubViewHeight = subviews.max {
            $0.sizeThatFits(.unspecified).height < $1.sizeThatFits(.unspecified).height
        }?.sizeThatFits(.unspecified).height ?? 0.0
        let extraSize = max(maxSubViewWidth, maxSubViewHeight)
        return CacheData(extraSize: extraSize, baseAngle: Angle(radians: Double.pi*2/Double(subviews.count)))
    }
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout CacheData) -> CGSize {
        
        if proposal == .zero {
            return CGSize(width: radius*2, height: radius*2)
        }
        if proposal == .infinity || proposal.width == nil || proposal.height == nil {
            return CGSize(width: radius*2 + cache.extraSize, height:radius*2 + cache.extraSize)
        }
        return CGSize(width: proposal.width!, height: proposal.height!)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout CacheData) {
        let sorted = subviews.sorted { a, b in
            a.priority > b.priority
        }
        let midX = bounds.width * center.x + bounds.minX
        let midY = bounds.height * center.y + bounds.minY
        
        for (index, view) in sorted.enumerated() {
            let angle = cache.baseAngle.radians*Double(index) + phase.radians
            
            let polarPt = CGPolarPoint(radius: radius - cache.extraSize/2.0, angle: angle)
            view.place(at: CGPoint(x:polarPt.cgpoint.x + midX, y: polarPt.cgpoint.y + midY), anchor: .center, proposal: proposal)
            /* For bi-directional custom layout values, it would be safer to unwrap it before invoke async block. In some situation, for example, switching content stack view in navigation split view when animating, might cause unwrap statment crash due to invalid address. */
            if let layoutValue = view[_RingStack.RotationValue.self] {
                DispatchQueue.main.async {
                    switch direction {
                    case .fixed:
                        layoutValue.wrappedValue = Angle(radians: direction.radians)
                    case .related:
                        layoutValue.wrappedValue = Angle(radians: angle + direction.radians)
                    }
                }
            }
        }
    }
    
    init(radius: CGFloat = 100.0, center: UnitPoint = .center, phase: Angle = .zero, direction: RingLayoutDirection = .none, traceName: String = "") {
        self.radius = radius
        self.center = center
        self.phase = phase
        self.direction = direction
        self.trace = traceName
    }
}

extension View {
    @available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, *)
    func layoutRotation(_ binding: Binding<Angle>) -> some View {
        self.layoutValue(key: _RingStack.RotationValue.self, value: binding)
    }
}

@available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, *)
fileprivate struct RingStackComponent<V: View>: View {
    @ViewBuilder let content: () -> V
    @State private var rotation: Angle = .zero
    var body: some View {
        content().rotationEffect(rotation).layoutRotation($rotation)
    }
}

@available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, *)
@MainActor public struct RingStack<Content: View> : View {

    let radius: CGFloat
    let center: UnitPoint
    let phase: Angle
    let direction: RingLayoutDirection
    var content: () -> Content
    let trace: String
    
    public var body: some View {
        GeometryReader { geo in
            _RingStack(radius: radius > 0 ? radius : max(min(geo.height, geo.width), 0.0)/2.0, center: center, phase: phase, direction: direction, traceName: trace) {
                content().variadic { children in
                    ForEach(0..<children.endIndex, id: \.self) { index in
                        RingStackComponent {
                            children[index]
                        }
                    }
                }
            }
        }
    }
    
    /// Creates an instance with the given radius, center, rotation phase, and layout direction.
    ///
    /// - Parameters:
    ///   - radius: The radius of the circle which the subviews are arranged around.
    ///   - center: Specifies the center of the circle.
    ///   - phase: The radians that the first view start with. Default is zero.
    ///   - direction: The guide for placing the subviews in this stack.
    ///   - content: A view builder that creates the content of this stack.
    @MainActor public init(radius: CGFloat = 100.0, center: UnitPoint = .center, phase: Angle = .zero, direction: RingLayoutDirection = .none, trace:String = "", @ViewBuilder content: @escaping () -> Content) {
        self.radius = radius
        self.center = center
        self.phase = phase
        self.direction = direction
        self.content = content
        self.trace = trace
    }
}
