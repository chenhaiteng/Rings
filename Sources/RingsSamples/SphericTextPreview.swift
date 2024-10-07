//
//  SwiftUIView.swift
//  Rings
//
//  Created by Chen Hai Teng on 10/7/24.
//

import SwiftUI
import Rings

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

#Preview {
#if os(tvOS)
    Text("No Preview Yet")
#else
    SphericTextDemo()
#endif
}


