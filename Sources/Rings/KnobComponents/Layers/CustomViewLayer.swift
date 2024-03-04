//
//  CustomViewLayer.swift
//
//
//  Created by Chen Hai Teng on 2/1/24.
//

import SwiftUI
import Common
import SwiftClamping

struct CustomViewLayer<V: View>: AngularLayer {
    private var content: () -> V
    public var isFixed: Bool = false
    public var offset: CGPoint = .zero
    public var radius: CGFloat = 0.0
    private var insets: EdgeInsets
    
    @Clamping(0.0...0.0) public var degree: Double = 0.0
    public var degreeRange: ClosedRange<Double> {
        get {
            $degree
        }
        set {
            $degree = newValue
        }
    }
    
    public var body: some View {
        ZStack(alignment: .center) {
            content().padding(insets).if(!isFixed, content: { content in
                content.rotationEffect(Angle.degrees(Double(degree)))
            })
        }.frame(width: radius*2.0, height: radius*2.0)
    }
    
    public init(_ fixed: Bool = false, insets: EdgeInsets = EdgeInsets(top: 10.0, leading: 10.0, bottom: 10.0, trailing: 10.0), @ViewBuilder _ content: @escaping () -> V) {
        self.isFixed = fixed
        self.content = content
        self.insets = insets
    }
}

extension CustomViewLayer : Adjustable {
    func insets(_ newValue: EdgeInsets) -> Self {
        setProperty { adjustObject in
            adjustObject.insets = newValue
        }
    }
}
