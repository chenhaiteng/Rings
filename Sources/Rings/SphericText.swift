//
//  SphericText.swift
//  Rings
//
//  Created by Chen Hai Teng on 3/7/21.
//

import SwiftUI
import CoreGraphicsExtension

struct SphericText<T:BinaryFloatingPoint>: View {
    
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
    @State private var estHight: CGFloat = 0.0
    
    init(words: [String], word_spacing: T = 30.0 , font: Font? = nil, word_color: Color = Color.white, word_background: Color = Color.clear, hide_opposite: Bool = false, degree_offset: Binding<T> = .constant(0)) {
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
    
    init(_ text: String, _ rotateDegree: Binding<T>) {
        let words = Array(text).map { c -> String in
            String(c)
        }
        let spacing = 360.0/Double(text.count)
        self.init(words: words, word_spacing: T(spacing), degree_offset: rotateDegree)
    }
    
    init(_ text: String, word_spacing: T, _ rotateDegree: Binding<T>) {
        let words = Array(text).map { c -> String in
            String(c)
        }
        self.init(words: words, word_spacing: word_spacing, degree_offset: rotateDegree)
    }
    
    init(list: [String], _ rotateDegree: Binding<T>) {
        let spacing = 360.0/Double(list.count)
        self.init(words: list, word_spacing: T(spacing), degree_offset: rotateDegree)
    }
    
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let frameL = geo.frame(in: .local)
            ZStack(alignment: .center) {
                //hide text to caculate height
                Sizing {
                    Text("A").font(font).opacity(0.0)
                }
                ForEach(stringTable, id: \.self.offset) { (i, e) in
                    let deg = Double(i)*wordSpacing + Double(offsetDegree)
                    let _ = print("degrees: \(deg)")
                    let normalizedD = Int(deg)%360
                    let shouldBlur = blurMinors ? (frontMostRange ~= normalizedD) : false
                    let shouldHide = hideOpposite ? (oppositeRange ~= abs(normalizedD)) : false
                    Text(e).frame(width: w/2, height: estHight, alignment: .center)
                        .font(font)
                        .foregroundColor(wordColor)
                        .background(wordBackground)
                        .rotation3DEffect(
                            .degrees(deg),
                            axis: (x: 0.0, y: 1.0, z: 0.0),
                            anchor: .center,
                            anchorZ: anchorZ,
                            perspective: perspective
                        ).opacity(shouldHide ? 0.0 : 1.0).blur(radius: shouldBlur ? 0.0 : 1.0)
                }

            }.frame(width: frameL.size.width, height: estHight).onPreferenceChange(ViewSizeKey.self) { sizes in
                estHight = (sizes.reduce(0, {$0 + $1.height}))/CGFloat(sizes.count)*CGFloat(1.1)
            }
        }
    }
}

extension SphericText : Adjustable {
    public func wordSpacing(_ spacing: Double) -> SphericText {
        setProperty { tmp in
            tmp.wordSpacing = spacing
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
    
    public func perspective(_ value: CGFloat) -> SphericText {
        setProperty { tmp in
            tmp.perspective = value
        }
    }
    
    public func radius(_ value: CGFloat) -> SphericText {
        setProperty { tmp in
            tmp.anchorZ = value
        }
    }
}

struct SphericTextDemo: View {
    @State var rotateDeg: Double = 0.0
    @State var showModifier: Bool = false
    @State var radius: CGFloat = 40.0
    @State var perspective: CGFloat = 0.0
    @State var characters = "ABCDE"
    @State var wordsInput = "Test\n100"
    @State var words = ["Test", "100"]
    
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
                Group {
                    ZStack {
                        SphericText(characters, $rotateDeg).hideOpposite(true).rangeOfOpposite(in: 145...210)
                            .radius(radius).perspective(perspective).frame(width: geo.size.width, height: 50)
                    }
                    HStack {
                        Spacer()
                        TextField("Input Spheric Characters", text: $characters).textFieldStyle(RoundedBorderTextFieldStyle())
                        Spacer()
                    }
                }
                Divider().background(Color.white)
                SphericText(words: words, degree_offset: $rotateDeg).wordSpacing(100.0).font( .system(size: 32.0)).wordColor(.red).hideOpposite(false).perspective(perspective).radius(radius).frame(width: geo.size.width)
                Spacer(minLength: 50.0)
                if #available(macOS 11.0, *) {
                    TextEditor(text: wordsInputBinding).textFieldStyle(RoundedBorderTextFieldStyle()).frame(width: 100, height: 100, alignment: .center)
                } else {
                    // Fallback on earlier versions
                }
                Divider().background(Color.white)
                Group {
                    HStack {
                        Spacer(minLength: 20)
                        Button(action: {
                            rotateDeg = 0.0
                        }, label: {
                            Text("Rotate").padding(5).overlay(RoundedRectangle(cornerRadius: 10.0).stroke())
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
                            Text("Radius").padding(5).overlay(RoundedRectangle(cornerRadius: 10.0).stroke())
                        })
                        Slider(value: $radius, in: 0...500)
                        Text("\(radius, specifier: "%.2f")").foregroundColor(.white)
                        Spacer(minLength: 20)
                    }
                    HStack {Spacer(minLength: 20)
                        Button(action: {
                            perspective = 0.0
                        }, label: {
                            Text("Perspective").padding(5).overlay(RoundedRectangle(cornerRadius: 10.0).stroke())
                        })
                        Slider(value: $perspective, in: -1...1)
                        Text("\(perspective, specifier: "%.2f")").foregroundColor(.white)
                        Spacer(minLength: 0)
                    }
                }
                Spacer(minLength: 40)
            }.background(Color.black)
        }
    }
}

struct SphericText_Previews:
    PreviewProvider {
    static var previews: some View {
        SphericTextDemo()
    }
}
