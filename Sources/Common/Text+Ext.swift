//
//  Text+Ext.swift
//
//
//  Created by Chen Hai Teng on 10/11/23.
//

import Foundation
import SwiftUI

/// Define a proxy object to provide style or color for Text on different os versions.
public protocol CompatibleForegroundProxy {
    var style: any ShapeStyle { get }
    var color: Color { get }
}

public extension Text {
    /// Wrap text foregraound method to make devloper setup text foreground with consistent statement on different os version.
    func compatibleForeground<T: CompatibleForegroundProxy>(_ compatibleObj: T) -> Text {
        if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
            return foregroundStyle(compatibleObj.style) as! Text
        } else {
            return foregroundColor(compatibleObj.color)
        }
    }
}
