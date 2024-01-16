//
//  CollectionExts.swift
//
//  Created by Chen Hai Teng on 4/22/21.
//

import Foundation

public extension Collection where Indices.Iterator.Element == Index {
    /// Safer random access for collections
    /// Refer to https://stackoverflow.com/a/37225027/505763
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

