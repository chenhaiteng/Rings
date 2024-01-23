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
            view.place(at: currentPolarPt.cgpoint.offset(anchorPt), anchor: anchor, proposal: proposal)
            
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
public struct ArcStack<Content: View> : View {
    let radius: Double
    let anchor: UnitPoint
    let range: ClosedRange<Double>
    let direction: RingLayoutDirection
    
    let content: () -> Content
    public var body: some View {
        _ArcStack(radius: radius, anchor: anchor, range: range, direction: direction) {
            content().variadic { children in
                ForEach(0..<children.endIndex, id: \.self) { index in
                    ArcStackComponent {
                        children[index]
                    }
                }
            }
        }
    }
    
    public init(radius: Double = 100.0,
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
}

@available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, *)
struct ArcStackPreview : View {
    
    let colors = [Color.red, Color.green, Color.blue, Color.yellow, Color.orange, Color.brown, Color.cyan]
    static let expandImage = "arrow.down.backward.and.arrow.up.forward.circle"
    static let collapseImage = "arrow.up.forward.and.arrow.down.backward.circle"
    static let arcSize = 300.0
    
    @State var clickedImage = "questionmark"
    @State var direction = RingLayoutDirection.none
    @State var anchor = UnitPoint.bottom
    @State var range = 0.0...1.0
    @State var radius = ArcStackPreview.arcSize/2.0
    @State var arcStateImage = expandImage
    @State var expandRadius = 0.0
    
    var body: some View {
        VStack {
            HStack(alignment: .bottom) {
                ZStack {
                    VStack {
                        Text("\(Image(systemName: "star")) and \(Image(systemName: "moon")) is clickable").multilineTextAlignment(.center).padding()
                        Image(systemName: clickedImage)
                        Spacer()
                    }.frame(height: 300.0)
                    ArcStack(radius: radius, anchor: anchor, range: range, direction: direction) {
                        Button {
                            clickedImage = "star"
                        } label: {
                            Image(systemName: "star")
                        }
                        ForEach(0..<colors.count, id: \.self) { index in
                            Text("\(index + 1)").frame(width: 20.0, height: 20.0).rounded(color: .white).background {
                                RoundedRectangle(cornerRadius: 5.0).fill(colors[index])
                            }
                        }
                        Button {
                            clickedImage = "moon"
                        } label: {
                            Image(systemName: "moon")
                        }
                    }.animation(.easeInOut(duration: 1.0), value: anchor).frame(width: Self.arcSize, height: Self.arcSize, alignment: .bottom)
                }
                ZStack(alignment:.leading) {
                    ArcStack(radius: expandRadius, anchor: anchor, range: 0.0...1.0, direction: .none) {
                        ForEach(0..<colors.count, id: \.self) { index in
                            Text("\(index + 1)").frame(width: 20.0, height: 20.0).rounded(color: .white).background {
                                RoundedRectangle(cornerRadius: 5.0).fill(colors[index])
                            }
                        }
                        Button {
                            DispatchQueue.main.async {
                                withAnimation(.linear(duration: 1.0)) {
                                    if arcStateImage == ArcStackPreview.expandImage {
                                        arcStateImage = ArcStackPreview.collapseImage
                                        expandRadius = radius
                                    } else {
                                        arcStateImage = ArcStackPreview.expandImage
                                        expandRadius = 0.0
                                    }
                                }
                            }
                        } label: {
                            Image(systemName: arcStateImage).resizable().frame(width: 20.0, height: 20.0)
                        }.buttonStyle(.borderedProminent)
                    }.frame(width: Self.arcSize, height: Self.arcSize, alignment: anchor.alignment)
                }.border(.blue.opacity(0.5))
            }
            Divider()
            Picker("direction", selection: $direction) {
                Text("none").tag(RingLayoutDirection.none)
                Text("to Center").tag(RingLayoutDirection.toCenter)
                Text("from Center").tag(RingLayoutDirection.fromCenter)
                Text("fixed 45˚").tag(RingLayoutDirection.fixed(degrees: 45))
                Text("related 45˚").tag(RingLayoutDirection.related(degrees: 45))
            }.pickerStyle(SegmentedPickerStyle()).padding(.horizontal, 20.0)
            Divider()
            Picker("anchor", selection: $anchor) {
                Image(systemName: "rectangle.leadingthird.inset.filled").tag(UnitPoint.leading)
                Image(systemName: "rectangle.inset.topleading.filled").tag(UnitPoint.topLeading)
                Image(systemName: "rectangle.topthird.inset.filled").tag(UnitPoint.top)
                Image(systemName: "rectangle.inset.toptrailing.filled").tag(UnitPoint.topTrailing)
                Image(systemName: "rectangle.trailingthird.inset.filled").tag(UnitPoint.trailing)
                Image(systemName: "rectangle.inset.bottomtrailing.filled").tag(UnitPoint.bottomTrailing)
                Image(systemName: "rectangle.bottomthird.inset.filled").tag(UnitPoint.bottom)
                Image(systemName: "rectangle.inset.bottomleading.filled").tag(UnitPoint.bottomLeading)
            }.pickerStyle(SegmentedPickerStyle()).padding(.horizontal, 20.0)
            Divider()
            Picker("arc range", selection: $range) {
                Text("full").tag(0...1.0)
                Text("0.0-0.5").tag(0.0...0.5)
                Text("0.25-0.75").tag(0.25...0.75)
                Text("0.5-1.0").tag(0.5...1.0)
            }.pickerStyle(SegmentedPickerStyle()).padding(.horizontal, 20.0)
            
        }
    }
}

#Preview {
    VStack {
        if #available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, *) {
            ArcStackPreview().frame(height: 450.0)
        }
    }
}
