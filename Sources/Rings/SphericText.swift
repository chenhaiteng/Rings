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

public struct TextComponent {
    let text: String
    let color: Color
    let font: Font?
}

public struct SphericText<T:BinaryFloatingPoint>: View {
    
    let rotateDegree: T
    private let textComponents: [TextComponent]
    
    private var textSpacing: Double = 30.0
    private var font: Font?
    private var wordColor = Color.white
    private var wordBackground = Color.clear
    private var hideOpposite = false
    private var blurMinors = false
    private var oppositeRange = -90...90
    private var frontMostRange = -10...10
    private var perspective: CGFloat = 0.0
    private var radius: CGFloat = 0.0
    private var writingDirection: WritingDirection = .LeftToRight
    @State private var estHeight: CGFloat = 30.0
    @State private var estWidth: CGFloat = 30.0
    
    
    public init(_ components: [TextComponent], rotateDegree: T) {
        textComponents = components
        font = .system(size: 40.0)
        self.rotateDegree = rotateDegree
    }
    
    public init(words: [String], word_spacing: T = 30.0 , font: Font? = nil, word_color: Color = Color.white, word_background: Color = Color.clear, hide_opposite: Bool = false, degree_offset: Binding<T> = .constant(0)) {
        textSpacing = Double(word_spacing)
        let defaultFont = font ?? .system(size: 40.0)
        self.font = defaultFont
        wordColor = word_color
        wordBackground = word_background
        hideOpposite = hide_opposite
        self.textComponents = words.map { word in
            TextComponent(text: word,color: word_color, font:defaultFont)
        }
        self.rotateDegree = degree_offset.wrappedValue
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
                let anchorZ = radius > 0 ? radius : w/2.0
                ForEach(0..<textComponents.count, id:\.self) { index in
                    let component = textComponents[index]
                    let positionInDegree =  Double(rotateDegree) + (writingDirection == .LeftToRight ? 1.0 : -1.0)*Double(index)*textSpacing
                    let normalizedD = Int(positionInDegree)%360
                    let shouldBlur = blurMinors ? !(frontMostRange ~= abs(normalizedD)) : false
                    let shouldHide = hideOpposite ? (oppositeRange ~= abs(normalizedD)) : false

                    let text = writingDirection == .RightToLeft ? String(component.text.reversed()) : component.text
                    VStack {
                        Text(text)
                            .font(component.font)
                            .foregroundColor(component.color)
                            .border(Color.blue)
                        Text("\(positionInDegree)")
                    }.rotation3DEffect(
                            .degrees(positionInDegree),
                            axis: (x: 0.0, y: 1.0, z: 0.0),
                            anchor: .center,
                            anchorZ: anchorZ,
                            perspective: perspective
                        ).opacity(shouldHide ? 0.0 : (shouldBlur ? 0.5 : 1.0))
                        .blur(radius: (shouldBlur ? 1.0 : 0.0)).frame(alignment: .center)
                    
                }
            }.frame(width: frameL.size.width, height: frameL.size.height).clipped()

        }
    }
}

extension SphericText : Adjustable {
    public func wordSpacing(_ spacing: T) -> SphericText {
        setProperty { tmp in
            tmp.textSpacing = Double(spacing)
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
            tmp.radius = CGFloat(value)
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
    var demoData: [TextComponent] {
        let font = Font.system(size: 48)
        if #available(iOS 15.0, *) {
            return [
                TextComponent(text: "A", color: .red, font: font),
                TextComponent(text: "B", color: .green, font: font),
                TextComponent(text: "C", color: .blue, font: font),
                TextComponent(text: "D", color: .yellow, font: font),
                TextComponent(text: "E", color: .pink, font: font),
                TextComponent(text: "F", color: .gray, font: font),
                TextComponent(text: "G", color: .purple, font: font),
                TextComponent(text: "H", color: .cyan, font: font),
                TextComponent(text: "I", color: .white, font: font)
            ]
        } else {
            // Fallback on earlier versions
            return [
                TextComponent(text: "A", color: .red, font: font),
                TextComponent(text: "B", color: .green, font: font),
                TextComponent(text: "C", color: .blue, font: font),
                TextComponent(text: "D", color: .yellow, font: font),
                TextComponent(text: "E", color: .pink, font: font),
                TextComponent(text: "F", color: .gray, font: font),
                TextComponent(text: "G", color: .purple, font: font),
                TextComponent(text: "I", color: .white, font: font)
            ]
        }
    }
    @State var rotateDeg: CGFloat = 0.0
    @State var showModifier: Bool = false
    @State var radius: CGFloat = 40.0
    @State var perspective: CGFloat = 0.0
    @State var characters = "ABCDEGMS"
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
                            SphericText(demoData, rotateDegree: rotateDeg)
                                .rangeOfOpposite(in: 145...210)
                                .perspective(perspective)
                                .blurMinors(blurMinors)
                                .hideOpposite(hideOpposite)
                                .frame(width: width)
                                .border(Color.blue, width: 1.0)
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
                        SphericText(words: words, degree_offset: $rotateDeg).wordSpacing(wordSpacing).font( .system(size: 32.0)).wordColor(textColor).wordBackground(backgroundColor).hideOpposite(false).perspective(perspective).frame(width: width).border(Color.blue, width: 1.0)
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
                        Slider(value: $rotateDeg, in:  0.0...360.0)
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
