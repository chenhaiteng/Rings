//
//  ArcStackPreview.swift
//  Rings
//
//  Created by Chen Hai Teng on 10/4/24.
//

import SwiftUI
import Rings

@available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, *)
struct ArcStackPreview : View {
    
    let colors = [Color.red, Color.green, Color.blue, Color.yellow, Color.orange, Color.brown, Color.cyan]
    static let expandImage = "arrow.down.backward.and.arrow.up.forward.circle"
    static let collapseImage = "arrow.up.forward.and.arrow.down.backward.circle"
    static let arcSize = 300.0
    
    @State var clickedImage = "questionmark"
    @State var direction = RingLayoutDirection.none
    @State var anchor = UnitPoint.bottom
    @State var range = 0.0...1.0
    @State var radius = ArcStackPreview.arcSize/2.0
    @State var arcStateImage = expandImage
    @State var expandRadius = 0.0
    
    var body: some View {
        VStack {
            HStack(alignment: .bottom) {
                ZStack {
                    VStack {
                        Text("\(Image(systemName: "star")) and \(Image(systemName: "moon")) is clickable").multilineTextAlignment(.center).padding()
                        Image(systemName: clickedImage)
                        Spacer()
                    }.frame(height: 300.0)
                    ArcStack(radius: radius, anchor: anchor, range: range, direction: direction) {
                        Button {
                            clickedImage = "star"
                        } label: {
                            Image(systemName: "star")
                        }
                        ForEach(0..<colors.count, id: \.self) { index in
                            Text("\(index + 1)").frame(width: 20.0, height: 20.0).rounded(color: .white).background {
                                RoundedRectangle(cornerRadius: 5.0).fill(colors[index])
                            }
                        }
                        Button {
                            clickedImage = "moon"
                        } label: {
                            Image(systemName: "moon")
                        }
                    }.animation(.easeInOut(duration: 1.0), value: anchor).frame(width: Self.arcSize, height: Self.arcSize)
                }
                ZStack(alignment:.leading) {
                    ArcStack(anchor: anchor, range: 0.0...1.0, direction: .none) {
                        ForEach(0..<colors.count, id: \.self) { index in
                            Text("\(index + 1)").frame(width: 20.0, height: 20.0).rounded(color: .white).background {
                                RoundedRectangle(cornerRadius: 5.0).fill(colors[index])
                            }
                        }
                        Button {
                            DispatchQueue.main.async {
                                withAnimation(.linear(duration: 1.0)) {
                                    if arcStateImage == ArcStackPreview.expandImage {
                                        arcStateImage = ArcStackPreview.collapseImage
                                        expandRadius = radius
                                    } else {
                                        arcStateImage = ArcStackPreview.expandImage
                                        expandRadius = 0.0
                                    }
                                }
                            }
                        } label: {
                            Image(systemName: arcStateImage).resizable().frame(width: 20.0, height: 20.0)
                        }.buttonStyle(.borderedProminent)
                    }.radius(expandRadius).frame(width: Self.arcSize, height: Self.arcSize)
                }.border(.blue.opacity(0.5))
            }
            Divider()
            Picker("direction", selection: $direction) {
                Text("none").tag(RingLayoutDirection.none)
                Text("to Center").tag(RingLayoutDirection.toCenter)
                Text("from Center").tag(RingLayoutDirection.fromCenter)
                Text("fixed 45˚").tag(RingLayoutDirection.fixed(degrees: 45))
                Text("related 45˚").tag(RingLayoutDirection.related(degrees: 45))
            }.pickerStyle(SegmentedPickerStyle()).padding(.horizontal, 20.0)
            Divider()
            Picker("anchor", selection: $anchor) {
                Image(systemName: "rectangle.leadingthird.inset.filled").tag(UnitPoint.leading)
                Image(systemName: "rectangle.inset.topleading.filled").tag(UnitPoint.topLeading)
                Image(systemName: "rectangle.topthird.inset.filled").tag(UnitPoint.top)
                Image(systemName: "rectangle.inset.toptrailing.filled").tag(UnitPoint.topTrailing)
                Image(systemName: "rectangle.trailingthird.inset.filled").tag(UnitPoint.trailing)
                Image(systemName: "rectangle.inset.bottomtrailing.filled").tag(UnitPoint.bottomTrailing)
                Image(systemName: "rectangle.bottomthird.inset.filled").tag(UnitPoint.bottom)
                Image(systemName: "rectangle.inset.bottomleading.filled").tag(UnitPoint.bottomLeading)
            }.pickerStyle(SegmentedPickerStyle()).padding(.horizontal, 20.0)
            Divider()
            Picker("arc range", selection: $range) {
                Text("full").tag(0...1.0)
                Text("0.0-0.5").tag(0.0...0.5)
                Text("0.25-0.75").tag(0.25...0.75)
                Text("0.5-1.0").tag(0.5...1.0)
            }.pickerStyle(SegmentedPickerStyle()).padding(.horizontal, 20.0)
            
        }
    }
}

#Preview {
    ZStack {
        if #available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, *) {
            ArcStackPreview().frame(height: 450.0)
        }
    }
}
