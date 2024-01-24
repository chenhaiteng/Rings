//
//  AlignmentAnchorMapping.swift
//
//
//  Created by Chen Hai Teng on 1/13/24.
//

import SwiftUI

public extension UnitPoint {
    var alignment: Alignment {
        switch (self.x, self.y) {
        case (0.0, 0.0):
                .topLeading
        case (1.0, 1.0):
                .bottomTrailing
        case (0.0, 1.0):
                .bottomLeading
        case (1.0, 0.0):
                .topTrailing
        case (0.0, _):
                .leading
        case (1.0, _):
                .trailing
        case (_, 0.0):
                .top
        case (_, 1.0):
                .bottom
        default:
                .center
        }
    }
}

public extension Alignment {
    var anchor: UnitPoint {
        switch self {
        case .bottom:
                .bottom
        case .bottomLeading:
                .bottomLeading
        case .bottomTrailing:
                .bottomTrailing
        case .top:
                .top
        case .topLeading:
                .topLeading
        case .topTrailing:
                .topTrailing
        case .leading:
                .leading
        case .trailing:
                .trailing
        case .center:
                .center
        default:
            UnitPoint.zero
        }
    }
}
