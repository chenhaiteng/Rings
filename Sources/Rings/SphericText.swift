//
//  SphericText.swift
//  Rings
//
//  Created by Chen Hai Teng on 3/7/21.
//

import SwiftUI
import CoreGraphicsExtension

public enum WritingDirection {
    case LeftToRight, RightToLeft
}

public struct SphericText<T:BinaryFloatingPoint>: View {
    
    @Binding var offsetDegree: T
    
    private let stringTable: [(offset: Int, element:String)]
    private var wordSpacing: Double = 30.0
    private var font: Font?
    private var wordColor = Color.white
    private var wordBackground = Color.clear
    private var hideOpposite = false
    private var blurMinors = false
    private var oppositeRange = 150...210
    private var frontMostRange = -10...10
    private var perspective: CGFloat = 0.0
    private var anchorZ: CGFloat = 100.0
    private var writingDirection: WritingDirection = .LeftToRight
    @State private var estHeight: CGFloat = 30.0
    @State private var estWidth: CGFloat = 30.0
    
    public init(words: [String], word_spacing: T = 30.0 , font: Font? = nil, word_color: Color = Color.white, word_background: Color = Color.clear, hide_opposite: Bool = false, degree_offset: Binding<T> = .constant(0)) {
        stringTable = words.enumerated().map { (i, e) in
            return (i, e)
        }
        _offsetDegree = degree_offset
        wordSpacing = Double(word_spacing)
        self.font = font ?? .system(size: 20.0)
        wordColor = word_color
        wordBackground = word_background
        hideOpposite = hide_opposite
    }
    
    public init(_ text: String, _ rotateDegree: Binding<T> = .constant(0)) {
        let words = Array(text).map { c -> String in
            String(c)
        }
        let spacing = 360.0/Double(text.count)
        self.init(words: words, word_spacing: T(spacing), degree_offset: rotateDegree)
    }
    
    public init(_ text: String, word_spacing: T, _ rotateDegree: Binding<T> = .constant(0)) {
        let words = Array(text).map { c -> String in
            String(c)
        }
        self.init(words: words, word_spacing: word_spacing, degree_offset: rotateDegree)
    }
    
    public init(words: [String], _ rotateDegree: Binding<T>) {
        let spacing = 360.0/Double(words.count)
        self.init(words: words, word_spacing: T(spacing), degree_offset: rotateDegree)
    }
    
    public var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let frameL = geo.frame(in: .local)
            ZStack(alignment: .center) {
                //hide text to caculate height
                Sizing {
                    Text("A").font(font).opacity(0.0)
                }
                ForEach(stringTable, id: \.self.offset) { i, element in
                    let positionInDegree =  Double(offsetDegree) + (writingDirection == .LeftToRight ? -1.0 : 1.0)*Double(i)*wordSpacing
                    let _ = print("degrees: \(positionInDegree)")
                    let normalizedD = Int(positionInDegree)%360
                    let shouldBlur = blurMinors ? !(frontMostRange ~= abs(normalizedD)) : false
                    let shouldHide = hideOpposite ? (oppositeRange ~= abs(normalizedD)) : false

                    let text = writingDirection == .RightToLeft ? String(element.reversed()) : element
                    Text(text).frame(width: estWidth*CGFloat(text.count), height: 50, alignment: Alignment(horizontal: .center, vertical: .center))
                        .font(font)
                        .foregroundColor(wordColor)
                        .background(wordBackground)
                        .rotation3DEffect(
                            .degrees(positionInDegree),
                            axis: (x: 0.0, y: 1.0, z: 0.0),
                            anchor: .center,
                            anchorZ: anchorZ,
                            perspective: perspective
                        ).opacity(shouldHide ? 0.0 : (shouldBlur ? 0.5 : 1.0))
                        .blur(radius: (shouldBlur ? 1.0 : 0.0))
                }.frame(width: w, height: estHeight, alignment: .center)

            }.frame(width: frameL.size.width, height: frameL.size.height).onPreferenceChange(ViewSizeKey.self) { sizes in
                estHeight = (sizes.reduce(0, {$0 + $1.height}))/CGFloat(sizes.count)*CGFloat(1.1)
                estWidth = (sizes.reduce(0, {$0 + $1.width}))/CGFloat(sizes.count)
            }

        }
    }
}

extension SphericText : Adjustable {
    public func wordSpacing(_ spacing: T) -> SphericText {
        setProperty { tmp in
            tmp.wordSpacing = Double(spacing)
        }
    }
    
    public func font(_ font: Font) -> SphericText {
        setProperty { tmp in
            tmp.font = font
        }
    }
    
    public func wordColor(_ color: Color) -> SphericText {
        setProperty { tmp in
            tmp.wordColor = color
        }
    }
    
    public func wordBackground(_ color: Color) -> SphericText {
        setProperty { tmp in
            tmp.wordBackground = color
        }
    }
    
    public func hideOpposite(_ isHidden: Bool) -> SphericText {
        setProperty { tmp in
            tmp.hideOpposite = isHidden
        }
    }
    
    public func rangeOfOpposite(in range: ClosedRange<Int>) -> SphericText {
        setProperty { tmp in
            tmp.oppositeRange = range
        }
    }
    
    public func rangeOfFrontMost(in range: ClosedRange<Int>) -> SphericText {
        setProperty { tmp in
            tmp.frontMostRange = range
        }
    }
    
    public func perspective(_ value: T) -> SphericText {
        setProperty { tmp in
            tmp.perspective = CGFloat(value)
        }
    }
    
    public func radius(_ value: T) -> SphericText {
        setProperty { tmp in
            tmp.anchorZ = CGFloat(value)
        }
    }
    
    public func blurMinors(_ isBlur: Bool) -> Self {
        setProperty { tmp in
            tmp.blurMinors = isBlur
        }
    }
    public func writingDirection(_ direction: WritingDirection) -> Self {
        setProperty { tmp in
            tmp.writingDirection = direction
        }
    }
}
