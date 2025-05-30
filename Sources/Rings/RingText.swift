import SwiftUI
import CoreGraphicsExtension
import Common

@available(iOS 14.0, macOS 11.0, tvOS 13.0, watchOS 6.0, *)
public extension CGAngle {
    func toAngle(offset radians: CGFloat = 0.0) -> Angle {
        Angle(radians: Double(self.radians + radians))
    }
}

@available(iOS 14.0, macOS 11.0, tvOS 13.0, watchOS 6.0, *)
public struct RingText : View, CompatibleForegroundProxy {
    private var radius: Double
    public var color: Color
    public var style: any ShapeStyle
    private var textUpsideDown: Bool
    
    private var char_spacing: Double
    private var kerning_r: Double
    private var beginRadians: Double
    private var endRadians: Double
    
    private var font = Font.system(size: 20.0)
    
    private var originwords: [String]
    private var characters: [String]
    private var textPoints: [CGPolarPoint] = []
    
    @State private var sizes: [CGSize] = []
    private var showBlueprint: Bool = false
    
    public init<T: BinaryFloatingPoint>(radius: T, color: Color = Color.white, upsideDown: Bool = false, begin: CGAngle = CGAngle.zero, end: CGAngle? = nil, @WordsBuilder _ builder: ()->[String]) {
        self.radius = Double(radius)
        self.color = color
        self.style = color
        self.textUpsideDown = upsideDown
        self.originwords = []
        
        characters = builder()
        
        beginRadians = Double(begin.radians)
        
        let count = characters.count-1
        let ratio = CGFloat(count)/CGFloat(characters.count)
        
        endRadians = Double(end?.radians ?? 2*CGFloat.pi*ratio+begin.radians)
        
        char_spacing = (endRadians - beginRadians)/Double(count)
        
        kerning_r = acos(1.0 - pow(20.0/self.radius, 2)/2.0)
        
        textPoints = _createTextPoints()
    }
    
    public init<T: BinaryFloatingPoint>(radius: T, text: String, color: Color = Color.white, upsideDown: Bool = false, begin: CGAngle = CGAngle.zero) {
        self.init(radius: radius, color: color, upsideDown: upsideDown,  begin: begin) {
            text
        }
    }
    
    private func _createTextPoints() -> [CGPolarPoint] {
        return characters.enumerated().map { index, element -> CGPolarPoint in
            return CGPolarPoint(radius: radius, angle: CGAngle(beginRadians + char_spacing * Double(index)))
        }
    }
    
    private func size(at index: Int) -> CGSize {
        sizes[safe: index] ?? CGSize(width: 100, height: 0)
    }
    
    public var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(Array(zip(characters.indices, characters)), id: \.0) { index, item in
                    let polarPt = self.textPoints[index]
                    let pt = polarPt.cgpoint
                    let textPt = CGPoint(x: pt.x, y: pt.y)
                    Sizing {
                        Text(item).font(font).compatibleForeground(self).if(showBlueprint) { content in
                            content.border(Color.blue.opacity(0.5), width:1)
                        }
                    }.rotationEffect(polarPt.cgangle.toAngle(offset: CGFloat.pi/2) + Angle.degrees(textUpsideDown ? 180 : 0)).offset(x: textPt.x, y: textPt.y)
                }
                
            }.frame(width: geo.size.width, height: geo.size.height, alignment: .center).onPreferenceChange(ViewSizeKey.self, perform: { value in
                Task { @MainActor in
                    sizes = value
                }
            })
        }
    }
}

extension RingText {
    func setProperty(_ setBlock: (_ text: inout Self) -> Void) -> Self {
        let result = _setProperty(content: self) { (tmp :inout Self) in
            setBlock(&tmp)
            return tmp
        }
        return result
    }
    
    @available(iOS, introduced: 14.0, deprecated: 100000.0, renamed: "foregroundStyle(_:)")
    @available(macOS, introduced: 11.0, deprecated: 100000.0, renamed: "foregroundStyle(_:)")
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, renamed: "foregroundStyle(_:)")
    @available(watchOS, introduced: 6.0, deprecated: 100000.0, renamed: "foregroundStyle(_:)")
    @available(visionOS, introduced: 1.0, deprecated: 100000.0, renamed: "foregroundStyle(_:)")
    public func textColor(_ color: Color) -> Self {
        setProperty { tmp in
            tmp.color = color
        }
    }
    
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public func foregroundStyle<S>(_ style: S) -> Self where S : ShapeStyle {
        setProperty { tmp in
            tmp.style = style
        }
    }
    
    public func kerning(_ pt: Double) -> Self {
        let r = acos(1.0 - pow(pt/self.radius, 2)/2.0)
        let adjusted = self.char_spacing - kerning_r + r
        return setProperty { tmp in
            tmp.kerning_r = pt
            tmp.char_spacing = adjusted
            tmp.textPoints = tmp._createTextPoints()
        }
    }
    
    public func begining(atDegrees: Double) -> Self {
        return begining(at: Double(CGAngle.degrees(atDegrees)))
    }
    
    public func begining(at radians: Double) -> Self {
        setProperty { tmp in
            let range = tmp.endRadians - tmp.beginRadians
            tmp.beginRadians = radians
            tmp.endRadians = radians + range
            tmp.char_spacing = (tmp.endRadians - tmp.beginRadians)/Double(tmp.characters.count-1)
            
            tmp.textPoints = tmp._createTextPoints()
        }
    }
    
    public func ending(atDegrees: Double) -> Self {
        return ending(at: Double(CGAngle.degrees(atDegrees)))
    }
    
    public func ending(at radians: Double) -> Self {
        setProperty { tmp in
            tmp.endRadians = radians
            tmp.char_spacing = (tmp.endRadians - tmp.beginRadians)/Double(tmp.characters.count-1)
            tmp.textPoints = tmp._createTextPoints()
        }
    }
    
    public func upsideDowning(_ upsideDown: Bool) -> Self {
        setProperty { tmp in
            tmp.textUpsideDown = upsideDown
        }
    }
    
    public func font(_ f: Font) -> Self {
        setProperty { tmp in
            tmp.font = f
        }
    }
    
    public func showingBlueprint(_ show: Bool) -> Self {
        setProperty { tmp in
            tmp.showBlueprint = show
        }
    }
}

@available(iOS 14.0, macOS 11.0, tvOS 13.0, watchOS 6.0, *)
struct RingText_Previews: PreviewProvider {
    static var previews: some View {
        #if os(tvOS)
        Text("No Preview Yet")
        #else
        RingTextPreviewWrapper()
        #endif
    }
}

@available(tvOS, unavailable)
struct RingTextPreviewWrapper: View {
    @State var spacing: Double = 0.0
    @State var begin: Double = 0.0
    @State var end: Double = 360.0
    @State var upside_down: Bool = false
    @State var reverse_text: Bool = false
    @State var begin_0: Double = 0.0
    @State var font_size: Double = 20.0
    @State var blueprint: Bool = false
    var body: some View {
        VStack {
            HStack {
                VStack {
                    ZStack {
                        RingText(radius: 40.0, color: .blue, upsideDown: false) {
                            "✪"
                            for i in 1...10 {
                                "\(i)"
                            }
                        }.font(Font.custom("Apple Chancery", size: 16.0)).begining(atDegrees: begin_0).showingBlueprint(blueprint).contentShape(Circle())
                        #if !os(tvOS)
                            .onTapGesture(count: 2, perform: {
                            begin_0 = 0.0
                            font_size = 20.0
                        })
                        #endif
                        RingText(radius: 80.0, text: "0987654321", color: .green).font(.system(size: CGFloat(font_size))).showingBlueprint(blueprint)
                    }
                    Text("begin degrees: \(begin_0)")
                    Slider(value: $begin_0, in: -360.0...360)
                    Text("font size: \(font_size)")
                    Slider(value: $font_size, in: 10.0...40.0, step: 1)
                }
                ZStack {
                    RingText(radius: 40.0) {
                        "a23"
                        "b56"
                        "c89"
                    }.showingBlueprint(blueprint)
                    RingText(radius: 80.0) {
                        "1234567890"
                    }.showingBlueprint(blueprint)
                }
                VStack {
                    ZStack {
                        RingText(radius: 60.0) {
                            if reverse_text {
                                "09876"
                                "54321"
                            } else {
                                "12345"
                                "67890"
                            }
                        }.begining(atDegrees: begin)
                        .ending(atDegrees: end)
                        .upsideDowning(upside_down)
                        .textColor(.red).showingBlueprint(blueprint)
                        RingText(radius: 40.0){
                            if reverse_text {
                                String("1234567890".reversed())
                            } else {
                                "1234567890"
                            }
                        }.kerning(spacing)
                        .upsideDowning(upside_down)
                        .textColor(.blue).showingBlueprint(blueprint)
                    }
                    VStack(alignment: .leading) {
                        Text("char kerning : \(spacing)")
                        Slider(value: $spacing, in: 0.0...30.0)
                        Text("begin degrees: \(begin)")
                        Slider(value: $begin, in: 0.0...360.0)
                        Text("end degrees: \(end)")
                        Slider(value: $end, in: 0.0...360.0)
                        Toggle("Upside Down", isOn: $upside_down)
                        Toggle("Reverse Text", isOn: $reverse_text)
                    }
                }
            }.background(Color.black)
            Toggle("Show Layout", isOn:$blueprint)
        }
    }
}
