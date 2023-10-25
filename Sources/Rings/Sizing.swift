//
//  Sizing.swift
//  
//  Use preference key to get child view size
//  Refer to:
//  1. https://swiftui-lab.com/communicating-with-the-view-tree-part-1/
//  2. https://www.youtube.com/watch?v=1BHHybRnHFE
//  3. https://www.fivestars.blog/articles/preferencekey-reduce/
//
//  Created by Chen Hai Teng on 4/22/21.
//

import SwiftUI

struct ViewSizeKey : PreferenceKey {
    static var defaultValue: [CGSize] = []
    static func reduce(value: inout [CGSize], nextValue: () -> [CGSize]) {
        value.append(contentsOf: nextValue())
    }
    typealias Value = [CGSize]
}

struct Sizing<V: View> : View {
    var content: ()->V
    var body: some View {
        content().background(GeometryReader { geo in
            Color.clear.preference(key: ViewSizeKey.self, value: [geo.size])
        })
    }
}
