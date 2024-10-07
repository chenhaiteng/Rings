//
//  SwiftUIView.swift
//  Rings
//
//  Created by Chen Hai Teng on 10/7/24.
//

import SwiftUI
import Rings

@available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, *)
struct RingStackPreview: View {
    @State var phase = Angle(degrees: -90.0)
    @State var wordSlider = 12.0
    @State var wordCount = 12
    @State var radius = 0.0
    @State var center: UnitPoint = .center
    @State var direction: RingLayoutDirection = .none
    @State var information: String = ""
    
    var body: some View {
        VStack {
            Text(information).frame(height: 20.0, alignment: .center)
            RingStack(radius: radius ,center: center, phase: phase, direction: direction) {
                VStack {
                    Image(systemName: "star").layoutPriority(1.0).onTapGesture {
                        information = "star tapped!"
                        center = .center
                        radius = 0.0
                        
                        if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
                            withAnimation(.linear(duration: 2.0)) {
                                phase = Angle(degrees: phase.degrees + 360.0)
                                center = .center
                                radius = 75.0
                            } completion: {
                                DispatchQueue.main.async {
                                    information = ""
                                    phase = Angle(degrees: phase.degrees - 360.0)
                                    radius = 0.0
                                }
                            }
                        } else {
                            withAnimation(.linear(duration: 2.0)) {
                                phase = Angle(degrees: phase.degrees + 360.0)
                                center = .center
                                radius = 100.0
                            }
                        }
                    }
                    Text("click!")
                }
                ForEach(1..<wordCount, id: \.self)  { num in
                    Text("\(num)").font(.title)
                }
            }.frame(width: 240.0, height: 240).border(.white)
            Divider()
            Picker("Ring Center", selection: $center) {
                Text("center").tag(UnitPoint.center)
                Text("top").tag(UnitPoint.top)
                Text("bottom").tag(UnitPoint.bottom)
                Text("leading").tag(UnitPoint.leading)
                Text("trailng").tag(UnitPoint.trailing)
            }.pickerStyle(SegmentedPickerStyle()).padding(EdgeInsets(top: 0.0, leading: 20.0, bottom: 0.0, trailing: 20.0))
            Picker("Stack Direction", selection: $direction) {
                Text("none").tag(RingLayoutDirection.none)
                Text("to center").tag(RingLayoutDirection.toCenter)
                Text("from center").tag(RingLayoutDirection.fromCenter)
                Text("cw").tag(RingLayoutDirection.alongClockwise)
                Text("ccw").tag(RingLayoutDirection.alongCounterClockwise)
                Text("fixed 45˚").tag(RingLayoutDirection.fixed(degrees: 45.0))
            }.pickerStyle(SegmentedPickerStyle()).padding(EdgeInsets(top: 0.0, leading: 20.0, bottom: 0.0, trailing: 20.0))
            Divider()
#if os(tvOS)
#else
            Slider(value: $phase.radians, in: -Double.pi...Double.pi, step: Double.pi/10.0) {
                Text("phase: \(phase.radians/Double.pi, specifier: "%.2f") π").frame(width: 100.0, alignment: .leading)
            }.padding(EdgeInsets(top: 0.0, leading: 20.0, bottom: 0.0, trailing: 20.0))
            Divider()
            Slider(value: $wordSlider, in: 1...24, step: 1) {
                Text("words: \(wordCount)").frame(width: 100.0, alignment: .leading)
            }.padding(EdgeInsets(top: 0.0, leading: 20.0, bottom: 0.0, trailing: 20.0))
            Divider()
            Spacer()
#endif
        }.onChange(of: wordSlider, perform: { value in
            DispatchQueue.main.async {
                wordCount = Int(value)
            }
        })
    }
}


@available(iOS, introduced: 14.0, deprecated: 16.0, renamed: "RingStackPreview")
struct RingListPreview : View {
    @State var phase = Angle(degrees: -90.0)
    var body: some View {
        RingList(phase: phase) {
            Image(systemName: "star")
            ForEach(1..<12) { num in
                Text("\(num)")
            }
        }
    }
}

#Preview {
    if #available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *) {
        return RingStackPreview()
    } else {
        return RingListPreview()
    }
}
