//
//  InternalUtilities.swift
//  
//
//  Created by Chen Hai Teng on 5/9/21.
//

import Foundation

internal func _setProperty<T>(content: T, _ setBlock:(_ newContent: inout T) -> T) -> T {
    var temp = content
    return setBlock(&temp)
}


public protocol Adjustable {}

extension Adjustable {
    func setProperty(_ setBlock: (_ text: inout Self) -> Void) -> Self {
        let result = _setProperty(content: self) { (tmp :inout Self) in
            setBlock(&tmp)
            return tmp
        }
        return result
    }
}
