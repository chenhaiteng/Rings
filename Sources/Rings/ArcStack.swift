//
//  ArcStack.swift
//
//
//  Created by Chen Hai Teng on 1/11/24.
//

import SwiftUI
import Common
import CoreGraphicsExtension

@available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, *)
struct _ArcStack: Layout {
    
    var radius: Double
    var anchor: UnitPoint
    var range: ClosedRange<Double>
    var direction: RingLayoutDirection
    
    var animatableData: RingLayoutDirection {
        get {
            direction
        }
        set {
            direction = newValue
        }
    }
    
    struct RotationValue : LayoutValueKey {
        static let defaultValue: Binding<Angle>? = nil
    }
    
    struct CacheData {
        var extraSize: Double
        var beginRadians: Double
        var stepRadians: Double
    }
    
    func makeCache(subviews: Subviews) -> CacheData {
        let maxSubViewWidth = subviews.max {
            $0.sizeThatFits(.unspecified).width < $1.sizeThatFits(.unspecified).width
        }?.sizeThatFits(.unspecified).width ?? 0.0
        let maxSubViewHeight = subviews.max {
            $0.sizeThatFits(.unspecified).height < $1.sizeThatFits(.unspecified).height
        }?.sizeThatFits(.unspecified).height ?? 0.0
        let extraSize = max(maxSubViewWidth, maxSubViewHeight)
        let _begin = beginAngle()
        let _end = endAngle()
        let _fullRange = _end.radians - _begin.radians
        let totalRange = (_end.radians - _begin.radians)*(range.upperBound - range.lowerBound)
        
        
        let steps = totalRange/steps(of: subviews)
        let begin = _begin.radians + _fullRange*range.lowerBound
        
        return CacheData(extraSize: extraSize, beginRadians: begin, stepRadians: steps)
    }
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout CacheData) -> CGSize {
        var size: CGSize = .zero
        switch anchor {
        case .top, .bottom:
            size = CGSize(width: radius*2.0, height: radius)
        case .leading, .trailing:
            size = CGSize(width: radius, height: radius*2.0)
        case .topLeading, .bottomLeading, .topTrailing, .bottomTrailing:
            size = CGSize(width: radius, height: radius)
        default:
            size = CGSize(width: radius*2.0, height: radius*2.0)
        }
        
        if proposal == .infinity {
            return CGSize(width: size.width + cache.extraSize, height: size.height + cache.extraSize)
        }
        return size
    }
    
    func anchor(in bounds: CGRect, cache: CacheData) -> CGPoint {
        CGPoint(x:bounds.minX +  anchor.x*bounds.width , y: bounds.minY + anchor.y*bounds.height)
    }
    
    func beginAngle() -> Angle {
        switch anchor {
        case .top:
            Angle.zero
        case .bottom:
            Angle(degrees: 180.0)
        case .leading:
            Angle(degrees: -90.0)
        case .trailing:
            Angle(degrees: 90.0)
        case .topLeading:
            Angle.zero
        case .topTrailing:
            Angle(degrees: 90.0)
        case .bottomLeading:
            Angle(degrees: -90.0)
        case .bottomTrailing:
            Angle(degrees: 180.0)
        default:
            Angle.zero
        }
    }
    
    func endAngle() -> Angle {
        switch anchor {
        case .top:
            Angle(degrees: 180.0)
        case .bottom:
            Angle(degrees: 360.0)
        case .leading:
            Angle(degrees: 90.0)
        case .trailing:
            Angle(degrees: 270.0)
        case .topLeading:
            Angle(degrees: 90.0)
        case .topTrailing:
            Angle(degrees: 180.0)
        case .bottomLeading:
            Angle(degrees: 0.0)
        case .bottomTrailing:
            Angle(degrees: 270.0)
        default:
            Angle(degrees: 360.0)
        }
    }
    
    func steps(of subviews: Subviews) -> Double {
        switch anchor {
        case .top, .bottom, .leading, .trailing, .topLeading, .topTrailing, .bottomLeading, .bottomTrailing:
            subviews.count > 1 ?
            Double(subviews.count - 1) : Double(subviews.count)
        default:
            range == 0.0...1.0 ? Double(subviews.count) : (subviews.count > 1 ? Double(subviews.count - 1) : Double(subviews.count))
        }
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout CacheData) {
        
        let anchorPt = anchor(in: bounds, cache: cache)
    
        for (index, view) in subviews.enumerated() {
            let currentRadians = cache.beginRadians + cache.stepRadians*Double(index)
            let currentPolarPt = CGPolarPoint(radius: radius > 0 ? radius - cache.extraSize : 0.0, angle: currentRadians)
            view.place(at: currentPolarPt.cgpoint >> anchorPt, anchor: anchor, proposal: proposal)
            
            /* For bi-directional custom layout values, it would be safer to unwrap it before invoke async block. In some situation, for example, switching content stack view in navigation split view when animating, might cause unwrap statment crash due to invalid address. */
            if let layoutValue = view[_ArcStack.RotationValue.self] {
                DispatchQueue.main.async {
                    switch direction {
                    case .related:
                        layoutValue.wrappedValue = Angle(radians: currentRadians + direction.radians)
                    case .fixed:
                        layoutValue.wrappedValue = Angle(radians: direction.radians)
                    }
                }
            }
        }
    }
    
    init(radius: Double, anchor: UnitPoint, range: ClosedRange<Double>, direction: RingLayoutDirection) {
        self.radius = radius
        self.anchor = anchor
        self.range = range
        self.direction = direction
    }
}

@available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, *)
fileprivate struct ArcStackComponent<V: View>: View {
    @ViewBuilder let content: () -> V
    @State private var rotation: Angle = .zero
    
    var body: some View {
        content().rotationEffect(rotation).layoutValue(key: _ArcStack.RotationValue.self, value: $rotation)
    }
}

@available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, *)
public struct ArcStack<Content: View> : View, Adjustable {
    var radius: Double
    var anchor: UnitPoint
    var range: ClosedRange<Double>
    var direction: RingLayoutDirection
    
    let content: () -> Content
    public var body: some View {
        GeometryReader { geo in
            _ArcStack(radius: radius >= 0 ? radius : max(min(geo.width, geo.height), 0.0)/2.0, anchor: anchor, range: range, direction: direction) {
                content().variadic { children in
                    ForEach(0..<children.endIndex, id: \.self) { index in
                        ArcStackComponent {
                            children[index]
                        }
                    }
                }
            }.frame(width: geo.width, height: geo.height, alignment: anchor.alignment).border(.white)
        }.border(.gray)
    }
    /// Creates an instance with the given radius, anchor point, arc range, and layout direction.
    ///
    /// - Parameters:
    ///   - radius: The radius of the circle which the subviews are arranged around. If the radius `<` 0.0, or it's not specified, the arc size depends on its frame.
    ///   - anchor: Specifies the anchor location of the arc. If the anchor is not on the boundary, it layouts views similiar to ``RingStack``
    ///   - range: The range to plcae views in the arc.
    ///   - direction: The guide for placing the subviews in this stack.
    ///   - content: A view builder that creates the content of this stack.
    public init(radius: Double = -1.0,
         anchor: UnitPoint = .bottom,
         range: ClosedRange<Double> = 0.0...1.0,
         direction: RingLayoutDirection = .none,
         @ViewBuilder content: @escaping () -> Content) {
        self.radius = radius
        self.anchor = anchor
        self.range = range
        self.direction = direction
        self.content = content
    }
    
    /// Sets the radius of the arc stack.
    /// - Parameter radius: The radius.
    /// - Returns: arc stack with the radius you specify.
    public func radius<F: BinaryFloatingPoint>(_ radius: F) -> Self {
        setProperty { adjustObject in
            adjustObject.radius = Double(radius)
        }
    }
    
    /// Sets the anchor of the arc stack.
    /// - Parameter anchor: The unit point that defines where the center of arc stack is within its bounds.
    /// - Returns: arc stack with the anchor you specify.
    public func anchor(_ anchor: UnitPoint) -> Self {
        setProperty { adjustObject in
            adjustObject.anchor = anchor
        }
    }
    
    /// Sets the range of the arc stack to place subviews.
    /// - Parameter range: the range to specify where to place subviews.
    /// The full range depends on the what the anchor defined. If the anchor is `.top`, `.bottom`, `.leading`, or `.trailing`, the full range maps to semi-circle. If the anchor is `.topLeading`, `.topTrailing`, `.bottomLeading`, or `bottomTrailing`, the full range maps to quarter-circle.
    /// Otherwise, the arc stack place its subviews as ``RingStack``
    /// - Returns: arc stack with the anchor you specify.
    public func range(_ range: ClosedRange<Double>) -> Self {
        setProperty { adjustObject in
            adjustObject.range = range
        }
    }
    
    /// Sets the layout direction of sub views in arc stack.
    /// - Parameter direction: The layout direction to define how sub views placed. The direction shows where the top of each sub views is towarding.
    /// - Returns: arc stack with the layout direction you specify.
    public func direction(_ direction: RingLayoutDirection) -> Self {
        setProperty { adjustObject in
            adjustObject.direction = direction
        }
    }
}
