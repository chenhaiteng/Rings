//
//  ClockIndexShape.swift
//  
//
//  Created by Chen Hai Teng on 2/16/24.
//

import SwiftUI

/// A shape to show clock index inside the frame of the view containing it.
public struct ClockIndexShape : Shape {
    
    /// The enum that defines the type of clock index.
    public enum IndexStyle : Sendable {
        /// Clock index for minutes, with this type, the clock index shape divides itself into 60 segments.
        case minute
        /// Clock index for hours, with this type, the clock index shape divides itself into 12 segments.
        case hour
        
        func strokeStyle(width: Double, height: Double, radius: Double) -> StrokeStyle {
            switch self {
            case .minute:
                StrokeStyle.minuteStyle(markWidth: width, markHeight: height, radius: radius)
            case .hour:
                StrokeStyle.hourStyle(markWidth: width, markHeight: height, radius: radius)
            }
        }
    }
    
    let markSize: CGSize
    let inset: CGFloat
    let indexStyle: IndexStyle
    
    public func path(in rect: CGRect) -> Path {
        let size = min(rect.width, rect.height) - inset * 2.0
        let r = size/2.0
        let bound = CGRect(x: rect.midX - r, y: rect.midY - r, width: size, height: size)
        return Path { p in
            p.addEllipse(in: bound)
        }.strokedPath(indexStyle.strokeStyle(width: markSize.width, height: markSize.height, radius: r))
    }
    
    /// Create a clock index shape with specified style, markSize, and inset amount.
    /// - Parameters:
    ///   - style: The style of clock index.
    ///   - markSize: The size of the mark which divides clock index into different segments.
    ///   - inset: The amount of the inset value.
    public init(_ style: IndexStyle, markSize: CGSize = CGSize(width: 1.0, height: 2.0), inset: CGFloat = 0.0) {
        self.indexStyle = style
        self.markSize = markSize
        self.inset = inset
    }
}

extension ClockIndexShape: InsettableShape {
    public func inset(by amount: CGFloat) -> ClockIndexShape {
        return ClockIndexShape(indexStyle, markSize: markSize, inset: inset + amount)
    }
}

extension ClockIndexShape {
    /// Create a hour index shape with given mark size
    /// - Parameter markSize: The size of the mark which divides clock index into segments.
    /// - Returns: A new hour style clock index with given mark size.
    static func hourIndexShape(markSize: CGSize)-> Self {
        ClockIndexShape(.hour, markSize: markSize)
    }
    
    /// Create a minute index shape with given mark size
    /// - Parameter markSize: The size of the mark which divides clock index into segments.
    /// - Returns: A new minute style clock index with given mark size.
    static func minuteIndexShape(markSize: CGSize)-> Self {
        ClockIndexShape(.minute, markSize: markSize)
    }
}
