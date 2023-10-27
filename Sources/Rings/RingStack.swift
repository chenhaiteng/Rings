//
//  RingStack.swift
//
//
//  Created by Chen Hai Teng on 10/19/23.
//

import SwiftUI
import CoreGraphicsExtension

struct Helper<Result: View>: _VariadicView_MultiViewRoot {
    var _body: (_VariadicView.Children) -> Result

    func body(children: _VariadicView.Children) -> some View {
        _body(children)
    }
}

extension View {
    func variadic<R: View>(@ViewBuilder process: @escaping (_VariadicView.Children) -> R) -> some View {
        _VariadicView.Tree(Helper(_body: process), content: { self })
    }
}

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

@available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, *)
public struct RingStack : Layout {
    public struct CacheData {
        var extraSize: CGFloat
        var baseAngle: Angle
    }
    
    private var radius: CGFloat
    private var phase: Angle
    
    var animatableData: Angle {
        get {
            phase
        }
        set {
            phase = newValue
        }
    }
    
    public func makeCache(subviews: Subviews) -> CacheData {
        let maxSubViewWidth = subviews.max {
            $0.sizeThatFits(.unspecified).width < $1.sizeThatFits(.unspecified).width
        }?.sizeThatFits(.unspecified).width ?? 0.0
        let maxSubViewHeight = subviews.max {
            $0.sizeThatFits(.unspecified).height < $1.sizeThatFits(.unspecified).height
        }?.sizeThatFits(.unspecified).height ?? 0.0
        let extraSize = max(maxSubViewWidth, maxSubViewHeight)
        return CacheData(extraSize: extraSize, baseAngle: Angle(radians: Double.pi*2/Double(subviews.count)))
    }
    
    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout CacheData) -> CGSize {
        
        if proposal == .zero {
            return CGSize(width: radius*2, height: radius*2)
        }
        if proposal == .infinity || proposal.width == nil || proposal.height == nil {
            return CGSize(width: radius*2 + cache.extraSize, height:radius*2 + cache.extraSize)
        }
        return CGSize(width: proposal.width!, height: proposal.height!)
    }
    
    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout CacheData) {
        let sorted = subviews.sorted { a, b in
            a.priority > b.priority
        }
        for (index, view) in sorted.enumerated() {
            let polarPt = CGPolarPoint(radius: radius, angle: cache.baseAngle.radians*Double(index) + phase.radians)
            view.place(at: CGPoint(x:polarPt.cgpoint.x + bounds.midX, y: polarPt.cgpoint.y + bounds.midY), anchor: .center, proposal: .unspecified)
        }
    }
    
    public init(radius: CGFloat = 100.0, phase: Angle = .zero) {
        self.radius = radius
        self.phase = phase
    }
    
}

#Preview {
    @State var phase = Angle(degrees: -90.0)
    if #available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *) {
        return VStack {
            RingStack(phase: phase) {
                ForEach(1..<12) { num in
                    Text("\(num)")
                }
                Image(systemName: "star").layoutPriority(1.0)
            }.drawingGroup()
            Divider()
            #if os(tvOS)
            #else
            Slider(value: $phase.radians)
            #endif
        }
    } else {
        return RingList(phase: phase) {
            Image(systemName: "star")
            ForEach(1..<12) { num in
                Text("\(num)")
            }
        }
    }
}
