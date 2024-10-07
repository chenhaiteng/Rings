//
//  HandAiguille.swift
//  
//
//  Created by Chen Hai Teng on 5/4/21.
//

import SwiftUI
import Foundation

public enum TimeUnit {
    case hour, minute, second
}

extension TimeUnit {
    public typealias RawValue = Calendar.Component
    public init?(rawValue: RawValue) {
        switch rawValue {
        case .hour: self = Self.hour
        case .minute: self = Self.minute
        case .second: self = Self.second
        default: return nil
        }
    }
}

public struct HandAiguille<Content: View, T: BinaryFloatingPoint> : View {
    
    @Binding private var time: T
    @State private var angle: Angle = Angle()
    
    private let content: () -> Content
    private var handSize: CGSize
    private var offset: CGFloat
    private var timeUnit: TimeUnit
    
    private var showBlueprint: Bool = false
    private var handPlaceholder: Color = .gray
    
    public init(size: CGSize = CGSize(width: 3.0, height: 50.0), offset: T = 1.5, time: Binding<T> = .constant(0), unit: TimeUnit = .second, @ViewBuilder content: @escaping () -> Content) {
        self.handSize = size
        self.offset = CGFloat(offset)
        _time = time
        timeUnit = unit
        self.content = content
    }
    
    public var body: some View {
        GeometryReader { geo in
            ZStack {
                let yoffset:CGFloat = handSize.height/2.0 - offset
                if(showBlueprint) {
                    Circle().stroke().frame(width:geo.size.width, height: geo.size.height)
                }
                Path { p in
                    p.move(to: CGPoint(x: 0.0, y: geo.size.height/2.0))
                    p.addLine(to: CGPoint(x: geo.size.width, y: geo.size.height/2.0))
                    p.move(to: CGPoint(x: geo.size.width/2, y: 0.0))
                    p.addLine(to: CGPoint(x: geo.size.width/2, y: geo.size.height))
                }.if(showBlueprint) { p in
                    p.stroke(Color.blue)
                }
                if(content() is EmptyView) {
                    handPlaceholder.frame(width: handSize.width, height: handSize.height, alignment: .center).offset(y: -yoffset).rotationEffect(angleOfTime(time))
                } else {
                    content().frame(width: handSize.width, height: handSize.height, alignment: .center).offset(y: -yoffset).rotationEffect(angleOfTime(time))
                }
            }
        }
    }
    
    private func angleOfTime(_ time: T) -> Angle {
        let t = Double(time)
        switch timeUnit {
        case .hour:
            let r = t.truncatingRemainder(dividingBy: 12.0)
            return Angle(degrees: r * 30.0)
        case .minute, .second:
            let r =
                t.truncatingRemainder(dividingBy: 60.0)
            return Angle(degrees: r * 6.0)
        }
    }
}

extension HandAiguille {
    func setProperty(_ setBlock: (_ handAiguille: inout Self) -> Void) -> Self {
        let result = _setProperty(content: self) { (tmp :inout Self) in
            setBlock(&tmp)
            return tmp
        }
        return result
    }
    
    public func blueprint(_ isOn:Bool = true) -> Self {
        setProperty { tmp in
            tmp.showBlueprint = isOn
        }
    }
}

public enum HandFactory {
    public static func makeAppleWatchStyleHand<T: BinaryFloatingPoint>(size: CGSize = CGSize(width: 4.0, height: 60.0), timeProvider: Binding<T>, unit: TimeUnit = .second) -> some View {
        HandAiguille(size: size, offset: 1.5, time: timeProvider, unit: unit) {
            VStack(spacing: 0) {
                Capsule().stroke().frame(width: size.width)
                Rectangle().frame(width: 2, height: 10, alignment: .center)
                Circle().stroke().frame(width: 3, height: 3, alignment: .center)
            }
        }
    }
}

struct RoundedBorder: ViewModifier {
    var cornerRadius:CGFloat = 5
    var color = Color.white
    var lineWidth:CGFloat = 1
    func body(content: Content) -> some View {
        content.padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(color, lineWidth: lineWidth)
            )
    }
}

extension View {
    public func rounded(_ cornerRadius:CGFloat = 5, color:Color = .white, width:CGFloat = 1) -> some View {
        modifier(RoundedBorder(cornerRadius: cornerRadius, color: color, lineWidth: width))
    }
}


@available(tvOS, unavailable)
struct AppleStyleHandPreview: View {
    @State var emulateTime: CGFloat = 0.0
    @State var showBlueprint: Bool = false
    @State var offset: CGFloat = 1.5
    @State var unit: TimeUnit = .second
    
    var body: some View {
        VStack {
            HStack {
                ZStack {
                    HandAiguille(size: CGSize(width: 4.0, height: 50.0), offset: offset, time: $emulateTime, unit: unit) {
                        GeometryReader { geo in
                            VStack(spacing: 0) {
                                Capsule().stroke()
                                Rectangle().frame(width: 2, height: 10, alignment: .center)
                                Circle().stroke().frame(width: 3, height: 3, alignment: .center)
                            }
                        }
                    }.blueprint(showBlueprint).frame(width: 100, height: 100, alignment: .center)
                }
                ZStack {
                    HandFactory.makeAppleWatchStyleHand(size: CGSize(width: 5.0, height: 80.0),timeProvider: $emulateTime, unit: .hour).frame(width: 120, height: 120, alignment: .center)
                    HandFactory.makeAppleWatchStyleHand(size: CGSize(width: 4.0, height: 60.0),timeProvider: $emulateTime, unit: .minute).frame(width: 120, height: 120, alignment: .center)
                }
            }
            
            HStack {
                Spacer(minLength: 10)
                Slider(value: $emulateTime, in: 0.0...60.0, minimumValueLabel: Text("0.0"), maximumValueLabel: Text("60.0")) {
                    
                    Text("time")
                        .rounded()
                }
                Spacer(minLength: 10)
            }
            HStack {
                Spacer(minLength: 10)
                Slider(value: $offset, in: 0.0...20.0, step: 0.5, minimumValueLabel: Text("0.0"), maximumValueLabel: Text("20.0")) {
                    Text("offset").rounded()
                }
                Spacer(minLength: 10)
            }
            HStack {
                Spacer(minLength: 10)
                #if os(watchOS)
                Picker("Time Unit", selection: $unit) {
                    Text("hour").tag(TimeUnit.hour)
                    Text("minute").tag(TimeUnit.minute)
                    Text("second").tag(TimeUnit.second)
                }
                #else
                Picker("Time Unit", selection: $unit) {
                    Text("hour").tag(TimeUnit.hour)
                    Text("minute").tag(TimeUnit.minute)
                    Text("second").tag(TimeUnit.second)
                }.pickerStyle(SegmentedPickerStyle())
                #endif
                Spacer(minLength: 10)
            }
            Toggle("show blueprint", isOn: $showBlueprint)
        }
    }
}

struct HandAiguille_Previews: PreviewProvider {
    static var previews: some View {
        #if os(tvOS)
        Text("No Preview Yet")
        #else
        AppleStyleHandPreview().frame(width: 350, height: 350, alignment: .center)
        #endif
    }
}
