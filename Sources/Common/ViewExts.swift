//
//  ViewExts.swift
//  
//
//  Created by Chen Hai Teng on 4/22/21.
//

import SwiftUI

public extension View {
    /// conditional rx-style statement
    /// Refer to https://stackoverflow.com/a/57685253/505763
    @ViewBuilder
    func `if`<Content: View>(_ conditional: Bool, content: (Self)->Content) -> some View {
        if(conditional) {
            content(self)
        } else {
            self
        }
    }
}

/// To support extract variadic views from ViewBuilder result.
/// Refer to https://chris.eidhof.nl/post/variadic-views/
struct VariadicHelper<Result: View>: _VariadicView_MultiViewRoot {
    var _body: (_VariadicView.Children) -> Result

    func body(children: _VariadicView.Children) -> some View {
        _body(children)
    }
}

public extension View {
    /// To extract variadic views from ViewBuilder result.
    /// Refer to https://chris.eidhof.nl/post/variadic-views/
    func variadic<R: View>(@ViewBuilder process: @escaping (_VariadicView.Children) -> R) -> some View {
        _VariadicView.Tree(VariadicHelper(_body: process), content: { self })
    }
}
