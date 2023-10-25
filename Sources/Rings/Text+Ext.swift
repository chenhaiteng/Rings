//
//  Text+Ext.swift
//
//
//  Created by Chen Hai Teng on 10/11/23.
//

import Foundation
import SwiftUI

public protocol CompatibleForeground {
    var style: any ShapeStyle { get }
    var color: Color { get }
}

extension Text {
    func compatibleForeground<T: CompatibleForeground>(_ compatibleObj: T) -> Text {
        if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
            return foregroundStyle(compatibleObj.style)
        } else {
            return foregroundColor(compatibleObj.color)
        }
    }
}
