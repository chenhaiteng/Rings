//
//  SwiftUIView.swift
//  
//
//  Created by Chen Hai Teng on 1/13/24.
//

import CoreFoundation

public extension CGPoint {
    func offset(_ offset: CGPoint) -> CGPoint {
        CGPoint(x: x + offset.x, y: y+offset.y)
    }
    
    func offset(_ offset: CGSize) -> CGPoint {
        CGPoint(x: x + offset.width, y: y + offset.height)
    }
    
    func offset<T: BinaryFloatingPoint>(dx: T = 0.0, dy: T = 0.0) -> CGPoint {
        CGPoint(x: x + CGFloat(dx), y: y + CGFloat(dy))
    }
}