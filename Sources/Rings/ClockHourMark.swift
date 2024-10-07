//
//  ClockHourMark.swift
//
//
//  Created by Chen Hai Teng on 10/19/23.
//

import Foundation
import SwiftUI
import CoreGraphicsExtension
import ViewExtractor

@available(iOS, introduced: 14.0, deprecated: 16.0, message: "Use RingStack to instead of.")
@available(macOS, deprecated: 13.0, message: "Use RingStack to instead of.")
@available(watchOS, deprecated: 9.0, message: "Use RingStack to instead of.")
@available(tvOS, deprecated: 16.0, message: "Use RingStack to instead of.")
public struct ClockHourMark<Mark: View>: View, Adjustable {
    
    private let markers: Mark
    private var radius: CGFloat = defaultRadius
    
    public init(@ViewBuilder _ markerBuilder: ()->Mark, color: Color = .white) {
        markers = markerBuilder()
    }
    
    public var body: some View {
        if #available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *) {
            Extract(markers) { list in
                RingStack(radius: radius, phase: .degrees(-60.0)) {
                    ForEach(0..<12) { idx in
                        list[idx]
                    }
                }
            }
        } else {
            Extract(markers) { list in
                RingList(radius: radius, phase: .degrees(-60.0)) {
                    ForEach(0..<12) { idx in
                        list[idx]
                    }
                }
            }
        }
    }
    
    public func radius<T: BinaryFloatingPoint>(_ value: T) -> Self {
        setProperty { adjustObject in
            adjustObject.radius = CGFloat(value)
        }
    }
}
