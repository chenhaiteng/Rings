//
//  PickerExt.swift
//
//
//  Created by Chen Hai Teng on 2/13/24.
//

import SwiftUI

public struct SegmentedPicker: ViewModifier {
    public func body(content: Content) -> some View {
        #if os(watchOS)
        content
        #else
        content.pickerStyle(SegmentedPickerStyle()).padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 7))
        #endif
    }
}

public struct ColoredPicker: ViewModifier {
    @Binding var selection: Color
    public func body(content: Content) -> some View {
        #if os(macOS) || os(iOS)
        if #available(macOS 11.0, iOS 14.0, macCatalyst 14.0, *) {
            ColorPicker("", selection: _selection)
        } else {
            content.modifier(SegmentedPicker())
        }
        #else
        content.modifier(SegmentedPicker())
        #endif
    }
}

public extension Picker {
    func segmented() -> some View {
        modifier(SegmentedPicker())
    }
    
    func colorPicker(_ selection: Binding<Color>) -> some View {
        modifier(ColoredPicker(selection: selection))
    }
}
