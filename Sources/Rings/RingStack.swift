//
//  RingStack.swift
//
//
//  Created by Chen Hai Teng on 10/19/23.
//

import SwiftUI
import CoreGraphicsExtension


// https://chris.eidhof.nl/post/variadic-views/
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
    private var direction: RingStackDirection
    
    
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
            
            let polarPt = CGPolarPoint(radius: radius, angle: angle)
            view.place(at: CGPoint(x:polarPt.cgpoint.x + midX, y: polarPt.cgpoint.y + midY), anchor: .center, proposal: proposal)
            DispatchQueue.main.async {
                if case .none = direction {
                    view[_RingStack.RotationValue.self]?.wrappedValue = .zero
                } else if case .fixed = direction {
                    view[_RingStack.RotationValue.self]?.wrappedValue = Angle(radians: direction.radians)
                } else {
                    view[_RingStack.RotationValue.self]?.wrappedValue = .radians(angle + direction.radians)
                }
            }
        }
    }
    
    init(radius: CGFloat = 100.0, center: UnitPoint = .center, phase: Angle = .zero, direction: RingStackDirection = .none) {
        self.radius = radius
        self.center = center
        self.phase = phase
        self.direction = direction
    }
}

public enum RingStackDirection : Hashable {
    case none
    case toCenter
    case fromCenter
    case alongClockwise
    case alongCounterClockwise
    case fixed(degrees: Double)
    
    var radians : Double {
        switch self {
        case .none:
            0.0
        case .toCenter:
            Double.pi/2.0
        case .fromCenter:
            -Double.pi/2.0
        case .alongClockwise:
            0.0
        case .alongCounterClockwise:
            -Double.pi
        case .fixed(let value):
            Angle(degrees: value).radians
        }
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
public struct RingStack<Content: View> : View {

    let radius: CGFloat
    let center: UnitPoint
    let phase: Angle
    let direction: RingStackDirection
    var content: () -> Content
    
    public var body: some View {
        GeometryReader { geo in
            _RingStack(radius: radius, center: center, phase: phase, direction: direction) {
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
    
    public init(radius: CGFloat = 100.0, center: UnitPoint = .center, phase: Angle = .zero, direction: RingStackDirection = .none, @ViewBuilder content: @escaping () -> Content) {
        self.radius = radius
        self.center = center
        self.phase = phase
        self.direction = direction
        self.content = content
    }
}

@available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, *)
struct RingStackPreview: View {
    @State var phase = Angle(degrees: -90.0)
    @State var wordSlider = 12.0
    @State var wordCount = 12
    @State var radius = 100.0
    @State var center: UnitPoint = .center
    @State var direction: RingStackDirection = .none
    @State var information: String = ""
    
    var body: some View {
        VStack {
            Text(information).frame(height: 20.0, alignment: .center)
            RingStack(radius: radius ,center: center, phase: phase, direction: direction) {
                VStack {
                    Image(systemName: "star").layoutPriority(1.0).onTapGesture {
                        information = "star tapped!"
                        center = .center
                        radius = 0.0
                        
                        if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
                            withAnimation(.linear(duration: 2.0)) {
                                phase = Angle(degrees: phase.degrees + 360.0)
                                center = .center
                                radius = 100.0
                            } completion: {
                                DispatchQueue.main.async {
                                    information = ""
                                    phase = Angle(degrees: phase.degrees - 360.0)
                                }
                            }
                        } else {
                            withAnimation(.linear(duration: 2.0)) {
                                phase = Angle(degrees: phase.degrees + 360.0)
                                center = .center
                                radius = 100.0
                            }
                        }
                    }
                    Text("click!")
                }
                ForEach(1..<wordCount, id: \.self)  { num in
                    Text("\(num)").font(.title)
                }
            }.frame(width: 240.0, height: 240).border(.white).drawingGroup().animation(.linear, value: direction)
            Divider()
            Picker("Ring Center", selection: $center) {
                Text("center").tag(UnitPoint.center)
                Text("top").tag(UnitPoint.top)
                Text("bottom").tag(UnitPoint.bottom)
                Text("leading").tag(UnitPoint.leading)
                Text("trailng").tag(UnitPoint.trailing)
            }.pickerStyle(SegmentedPickerStyle()).padding(EdgeInsets(top: 0.0, leading: 20.0, bottom: 0.0, trailing: 20.0))
            Picker("Stack Direction", selection: $direction) {
                Text("none").tag(RingStackDirection.none)
                Text("to center").tag(RingStackDirection.toCenter)
                Text("from center").tag(RingStackDirection.fromCenter)
                Text("cw").tag(RingStackDirection.alongClockwise)
                Text("ccw").tag(RingStackDirection.alongCounterClockwise)
                Text("fixed 45˚").tag(RingStackDirection.fixed(degrees: 45.0))
            }.pickerStyle(SegmentedPickerStyle()).padding(EdgeInsets(top: 0.0, leading: 20.0, bottom: 0.0, trailing: 20.0))
            Divider()
#if os(tvOS)
#else
            Slider(value: $phase.radians, in: -Double.pi...Double.pi, step: Double.pi/10.0) {
                Text("phase: \(phase.radians/Double.pi, specifier: "%.2f") π").frame(width: 100.0, alignment: .leading)
            }.padding(EdgeInsets(top: 0.0, leading: 20.0, bottom: 0.0, trailing: 20.0))
            Divider()
            Slider(value: $wordSlider, in: 1...24, step: 1) {
                Text("words: \(wordCount)").frame(width: 100.0, alignment: .leading)
            }.padding(EdgeInsets(top: 0.0, leading: 20.0, bottom: 0.0, trailing: 20.0))
            Divider()
            Spacer()
#endif
        }.onChange(of: wordSlider, perform: { value in
            DispatchQueue.main.async {
                wordCount = Int(value)
            }
        })
    }
}


@available(iOS, introduced: 14.0, deprecated: 16.0, renamed: "RingStackPreview")
struct RingListPreview : View {
    @State var phase = Angle(degrees: -90.0)
    var body: some View {
        RingList(phase: phase) {
            Image(systemName: "star")
            ForEach(1..<12) { num in
                Text("\(num)")
            }
        }
    }
}

#Preview {
    if #available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *) {
        return RingStackPreview()
    } else {
        return RingListPreview()
    }
}
