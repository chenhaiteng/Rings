//
//  ViewExts.swift
//  
//  Refer to https://stackoverflow.com/a/57685253/505763
//  Created by Chen Hai Teng on 4/22/21.
//

import SwiftUI

public extension View {
    @ViewBuilder
    func `if`<Content: View>(_ conditional: Bool, content: (Self)->Content) -> some View {
        if(conditional) {
            content(self)
        } else {
            self
        }
    }
}
