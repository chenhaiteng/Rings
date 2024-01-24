//
//  File.swift
//  
//
//  Created by Chen Hai Teng on 8/26/21.
//

import Foundation

@resultBuilder
@frozen public enum WordsBuilder {
    public typealias Expression = String
    public typealias Component = [String]
    public typealias Result = [String]
    
    public static func buildBlock() -> Component {
        return []
    }
    
    public static func buildBlock(_ components: Component...) -> Component {
        return components.flatMap{$0}
    }
}

extension WordsBuilder {
    public static func buildExpression(_ expression: Expression) -> Component {
        return [expression, " "]
    }
    public static func buildArray(_ components: [Component]) -> Component {
        return components.flatMap { $0 }
    }
    
    public static func buildEither(first component: Component) -> Component {
        return component
    }
    
    public static func buildEither(second component: Component) -> Component {
        return component
    }
    
    public static func buildOptional(_ component: Component?) -> Component {
        return component ?? []
    }
    
    public static func buildFinalResult(_ component: Component) -> Result {
        let result = component.flatMap{ $0 }.flatMap { c in
            [String(c)]
        }
        
        if component.count == 2 {
            return result.dropLast()
        } else {
            return result
        }
    }
}
