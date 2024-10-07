//
//  SwiftUIView.swift
//  Rings
//
//  Created by Chen Hai Teng on 10/6/24.
//

import SwiftUI
import Rings

struct ClockHourMarkPreview: View {
    
#if os(watchOS)
    let margin: CGFloat = 0.0
#else
#if targetEnvironment(macCatalyst)
    let margin: CGFloat = 100.0
#else
    let margin: CGFloat = 20.0
#endif
#endif
    
#if os(watchOS) || os(macOS) || os(tvOS)
    let invertColor = false
#else
#if targetEnvironment(macCatalyst)
    let invertColor = false
#else
    let invertColor = true
#endif
#endif
    
    var body: some View {
        GeometryReader { geo in
            let radius = min(geo.height, geo.width)/2.0 - margin
            ClockHourMark {
                ForEach(1..<13) { idx in
                    Text("\(idx)").if(invertColor) { $0.colorInvert() }.font(.title.italic().bold())
                }
            }.radius(radius).frame(width: geo.size.width, height: geo.size.height)
        }
    }
}

struct ClockHourMark_Preview: PreviewProvider {
    
    static var previews: some View {
        Group {
            ClockHourMarkPreview().background(Color.black)
        }
    }
}

//Previews
@available(tvOS, unavailable)
struct ClockIndexPreview_iPhone : View {
    @State var showIndex: Bool = true
    @State var hourRadius: CGFloat = 100
    @State var minRadius: CGFloat = 100
    @State var hourIndexWidth: CGFloat = 2
    @State var hourIndexHeight: CGFloat = 5
    @State var minIndexWidth: CGFloat = 1
    @State var minIndexHeight: CGFloat = 5
    
    var body: some View {
        VStack {
            Spacer(minLength: 10.0)
            Text("Clock Index")
            VStack {
                ClockIndex().minuteIndex(style:StrokeStyle.minuteStyle(markWidth: minIndexWidth, markHeight: minIndexHeight, radius: minRadius), color: .blue, radius: minRadius).hourIndex(style: StrokeStyle.hourStyle(markWidth: hourIndexWidth, markHeight: hourIndexHeight, radius: hourRadius), color: .red, radius: hourRadius)
                HStack {
                    Spacer(minLength: 5.0)
                    Text("Hour Index Style")
                    VStack {
                        Divider()
                    }
                }
                HStack(spacing: 10.0) {
                    Spacer()
                    VStack(alignment: .leading) {
                        HStack(spacing: 10.0) {
                            Text("width")
                            Slider(value:$hourIndexWidth, in: 2...5)
                            Text(String(format:"%.2f", hourIndexWidth))
                        }
                        HStack(spacing: 10.0) {
                            Text("height")
                            Slider(value:$hourIndexHeight, in: 0...15)
                            Text(String(format:"%.2f", hourIndexHeight))
                        }
                        HStack(spacing: 10.0) {
                            Text("radius")
                            Slider(value: $hourRadius, in: 60...120, step: 5.0)
                            Text(String(format: "%.2f", hourRadius))
                        }
                    }
                    Spacer()
                }
                HStack {
                    Spacer(minLength: 5.0)
                    Text("Minute Index Style")
                    VStack {
                        Divider()
                    }
                }
                HStack(spacing: 10.0) {
                    Spacer()
                    VStack(alignment: .leading) {
                        HStack(spacing: 10.0) {
                            Text("width")
                            Slider(value:$minIndexWidth, in: 1...5)
                            Text(String(format:"%.2f", minIndexWidth))
                        }
                        HStack(spacing: 10.0) {
                            Text("height")
                            Slider(value:$minIndexHeight, in: 1...10)
                            Text(String(format:"%.2f", minIndexHeight))
                        }
                        HStack {
                            Text("radius")
                            Slider(value: $minRadius, in: 60...120)
                            Text(String(format: "%.2f", minRadius))
                        }
                    }
                    Spacer()
                }
            }
            
        }
    }
}

@available(tvOS, unavailable)
struct ClockIndexPreview_MacOS : View {
    @State var showIndex: Bool = true
    @State var hourRadius: CGFloat = 80
    @State var minRadius: CGFloat = 80
    @State var hourIndexWidth: CGFloat = 2
    @State var hourIndexHeight: CGFloat = 5
    @State var minIndexWidth: CGFloat = 1
    @State var minIndexHeight: CGFloat = 5
    var body: some View {
        VStack {
            Spacer(minLength: 10.0)
            Text("Clock Index")
            VStack {
                ClockIndex().minuteIndex(markSize: CGSize(width: minIndexWidth, height: minIndexHeight)).minuteIndex(radius: minRadius).hourIndex(style: StrokeStyle.hourStyle(markWidth: hourIndexWidth, markHeight: hourIndexHeight, radius: hourRadius), color: .red).hourIndex(radius: hourRadius).minuteIndexColor {
                Color.red
                Color.blue
                Color.yellow
            }.hourIndexColor {
                Color.yellow
                Color.red
                Color.blue
            }.frame(width: 200.0, height: 300.0)
                HStack {
                    Spacer()
                    Text("hour index style")
                    VStack {
                        Divider()
                    }
                }
                HStack(spacing: 10.0) {
                    Spacer()
                    VStack(alignment: .leading) {
                        HStack(spacing: 10.0) {
                            Text("w")
                            Slider(value:$hourIndexWidth, in: 2...5)
                            Text(String(format:"%.2f", hourIndexWidth))
                            Divider()
                            Text("h")
                            Slider(value:$hourIndexHeight, in: 0...15)
                            Text(String(format:"%.2f", hourIndexHeight))
                            Divider()
                            Text("r")
                            Slider(value: $hourRadius, in: 60...180)
                            Text(String(format: "%.2f", hourRadius))
                        }
                    }
                    Spacer()
                }
                HStack {
                    Spacer()
                    Text("minute index style")
                    VStack {
                        Divider()
                    }
                }
                HStack(spacing: 10.0) {
                    Spacer()
                    VStack(alignment: .leading) {
                        HStack(spacing: 10.0) {
                            Text("w")
                            Slider(value:$minIndexWidth, in: 1...5, step: 1.0)
                            Text(String(format:"%.2f", minIndexWidth))
                            Text("h")
                            Slider(value:$minIndexHeight, in: 1...5, step: 1.0)
                            Text(String(format:"%.2f", minIndexHeight))
                            Text("r")
                            Slider(value: $minRadius, in: 60...180)
                            Text(String(format: "%.2f", minRadius))
                        }
                    }
                    Spacer()
                }
                Spacer()
            }
            
        }
    }
}

struct ClockIndexPreview_Watch : View {
    @State var showIndex: Bool = true
    @State var hourIndexWidth: CGFloat = 2
    @State var hourIndexHeight: CGFloat = 5
    @State var minIndexWidth: CGFloat = 1
    @State var minIndexHeight: CGFloat = 5
    var body: some View {
        VStack {
            GeometryReader { geo in
                let watchRadius = min(geo.width, geo.height)/2.0
                ClockIndex().minuteIndex(style:StrokeStyle.minuteStyle(markWidth: minIndexWidth, markHeight: minIndexHeight, radius: watchRadius), color: .blue).minuteIndex(radius: watchRadius).hourIndex(style: StrokeStyle.hourStyle(markWidth: hourIndexWidth, markHeight: hourIndexHeight, radius: watchRadius), color: .red).hourIndex(radius: watchRadius).minuteIndexColor {
                    Color.red
                    Color.blue
                    Color.yellow
                }.hourIndexColor {
                    Color.yellow
                    Color.red
                    Color.blue
                }
            }
        }
    }
}

struct ClockIndex_Preview_tvOS : View {
    @State var hourRadius: CGFloat = 200
    @State var minRadius: CGFloat = 200
    @State var hourIndexWidth: CGFloat = 5
    @State var hourIndexHeight: CGFloat = 20
    @State var minIndexWidth: CGFloat = 5
    @State var minIndexHeight: CGFloat = 10
    
    var body: some View {
        VStack {
            VStack {
                ClockIndex().minuteIndex(style:StrokeStyle.minuteStyle(markWidth: minIndexWidth, markHeight: minIndexHeight, radius: minRadius), color: .blue, radius: minRadius).hourIndex(style: StrokeStyle.hourStyle(markWidth: hourIndexWidth, markHeight: hourIndexHeight, radius: hourRadius), color: .red, radius: hourRadius)
            }
            
        }
    }
}


struct ClockIndex_Previews: PreviewProvider {
    static var previews: some View {
#if os(iOS)
        ClockIndexPreview_iPhone().background(Color.white)
#endif
#if os(macOS)
        ClockIndexPreview_MacOS().background(Color.black).previewLayout(.sizeThatFits)
#endif
#if os(watchOS)
        ClockIndexPreview_Watch()
#endif
#if os(tvOS)
        ClockIndex_Preview_tvOS()
#endif
    }
}

