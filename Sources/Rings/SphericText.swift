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

@available(tvOS, unavailable)
struct SphericTextDemo: View {
    @State var rotateDeg: CGFloat = 0.0
    @State var showModifier: Bool = false
    @State var radius: CGFloat = 40.0
    @State var perspective: CGFloat = 0.0
    @State var characters = "ABCDE"
    @State var wordsInput = "Test\n100"
    @State var words = ["Test", "100"]
    @State var blurMinors: Bool = false
    @State var hideOpposite: Bool = false
    @State var textColor: Color = .white
    @State var backgroundColor: Color = .clear
    @State var wordSpacing: CGFloat = 100.0
    
    var body: some View {
        let wordsInputBinding = Binding<String>(get: {
            self.wordsInput
        }, set: {
            self.wordsInput = $0
            self.words = self.wordsInput.split(separator: "\n").map({ word -> String in
                String(word)
            })
        })
        GeometryReader { geo in
            VStack {
                HStack {
                    let width = geo.size.width/2
                    VStack {
                        ZStack {
                            SphericText(characters, $rotateDeg).rangeOfOpposite(in: 145...210)
                                .radius(radius)
                                .perspective(perspective)
                                .blurMinors(blurMinors)
                                .hideOpposite(hideOpposite)
                                .frame(width: width)
                        }
                        HStack {
                            Spacer()
                            #if os(iOS)
                                TextField("Input Spheric Characters", text: $characters).textFieldStyle(RoundedBorderTextFieldStyle())
                            #endif
                            Spacer()
                        }
                        Toggle("Blur Minor", isOn: $blurMinors)
                        Toggle("Hide Opposite", isOn: $hideOpposite)
                    }
                    Divider().background(Color.white)
                    VStack {
                        SphericText(words: words, degree_offset: $rotateDeg).wordSpacing(wordSpacing).font( .system(size: 32.0)).wordColor(textColor).wordBackground(backgroundColor).hideOpposite(false).perspective(perspective).radius(radius).frame(width: width)
                        #if os(iOS)
                        if #available(macOS 11.0, iOS 14.0, *) {
                            TextEditor(text: wordsInputBinding).textFieldStyle(RoundedBorderTextFieldStyle()).frame(width: 100, height: 80, alignment: .center)
                        } else {
                            // Fallback on earlier versions
                            Text(words.reduce("", { result, word in
                                result + word + ","
                            }))
                        }
                        #endif
                        HStack {
                            Spacer()
                            Text("text:")
                            Picker("", selection: $textColor) {
                                Text("White").tag(Color.white)
                                Text("Red").tag(Color.red)
                                Text("Blue").tag(Color.blue)
                                Text("Green").tag(Color.green)
                            }.colorPicker($textColor)
                            Spacer()
                            Text("background:")
                            Picker("", selection: $backgroundColor) {
                                Text("Clear").tag(Color.clear)
                                Text("White").tag(Color.white)
                                Text("Red").tag(Color.red)
                                Text("Blue").tag(Color.blue)
                                Text("Green").tag(Color.green)
                            }.colorPicker($backgroundColor)
                            Spacer()
                        }
                        HStack {
                            Spacer(minLength: 20)
                            Button(action: {
                                wordSpacing = 100.0
                            }, label: {
                                Text("word spacing")
                            })
                            Slider(value: $wordSpacing, in: 50...200, step: 5.0)
                            Text("\(wordSpacing, specifier: "%.2f")").foregroundColor(.white)
                            Spacer(minLength: 20)
                        }
                    }
                }
                Divider().background(Color.white)
                Group {
                    HStack {
                        Spacer(minLength: 20)
                        Button(action: {
                            rotateDeg = 0.0
                        }, label: {
                            Text("Rotate")
                        })
                        Slider(value: $rotateDeg, in:  -360.0...360.0)
                        Text("\(rotateDeg, specifier: "%.2f")").foregroundColor(.white)
                        Spacer(minLength: 20)
                    }
                    HStack {
                        Spacer(minLength: 20)
                        Button(action: {
                            radius = 40.0
                        }, label: {
                            Text("Radius")
                        })
                        Slider(value: $radius, in: 0...500)
                        Text("\(radius, specifier: "%.2f")").foregroundColor(.white)
                        Spacer(minLength: 20)
                    }
                    HStack {Spacer(minLength: 20)
                        Button(action: {
                            perspective = 0.0
                        }, label: {
                            Text("Perspective")
                        })
                        Slider(value: $perspective, in: -1...1)
                        Text("\(perspective, specifier: "%.2f")").foregroundColor(.white)
                        Spacer(minLength: 20)
                    }
                }
                Spacer(minLength: 10)
            }.background(Color.black)
        }
    }
}

struct SphericText_Previews:
    PreviewProvider {
    static var previews: some View {
#if os(tvOS)
        Text("No Preview Yet")
#else
        SphericTextDemo()
#endif
    }
}
