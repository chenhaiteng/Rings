import SwiftUI
import CoreGraphicsExtension

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public extension CGAngle {
    func toAngle(offset radians: CGFloat = 0.0) -> Angle {
        Angle(radians: Double(self.radians + radians))
    }
}

private func _createCharacters(origin: [String], reversed:Bool = false) -> [String] {
    var tmpWords = reversed ? origin.reversed() : origin
    if(reversed) {
        tmpWords = tmpWords.map({ word -> String in
            String(word.reversed())
        })
    }
    let text = (tmpWords.count == 1) ? tmpWords[0] : tmpWords.reduce(String()) {
        result, element -> String in
        result + element + " "
    }
    let characters = text.map(String.init)
    return characters
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct RingText : View {
    var radius: Double
    var textColor: Color
    var textUpsideDown: Bool
    var textReversed: Bool
    
    var char_spacing: Double
    var beginRadians: Double
    var endRadians: Double
    
    private var font = Font.system(size: 20.0)
    
    private var originwords: [String]
    private var characters: [String]
    private var textPoints: [CGPolarPoint] = []
    
    public init(radius: Double, words: [String], color: Color = Color.white, upsideDown: Bool = false, reversed: Bool = false, begin: CGAngle = CGAngle.zero, end: CGAngle? = nil) {
        self.radius = radius
        self.textColor = color
        self.textUpsideDown = upsideDown
        self.textReversed = reversed
        self.originwords = words
        
        characters = _createCharacters(origin: words, reversed: reversed)
        
        beginRadians = Double(begin.radians)
        
        let count = characters.count-1
        let ratio = CGFloat(count)/CGFloat(characters.count)
        
        endRadians = Double(end?.radians ?? 2*CGFloat.pi*ratio+begin.radians)
        
        char_spacing = (endRadians - beginRadians)/Double(count)
        
        textPoints = _createTextPoints()
    }
    
    public init(radius: Double, text: String, color: Color = Color.white, upsideDown: Bool = false, reversed: Bool = false, begin: CGAngle = CGAngle.zero) {
        self.init(radius: radius, words: [text], color: color, upsideDown: upsideDown, reversed: reversed, begin: begin)
    }
    
    private func _createTextPoints() -> [CGPolarPoint] {
        return characters.enumerated().map { index, element -> CGPolarPoint in
            return CGPolarPoint(radius: radius, angle: CGAngle(beginRadians + char_spacing * Double(index)))
        }
    }
    
    public var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(Array(zip(characters.indices, characters)), id: \.0) { index, item in
                    let polarPt = self.textPoints[index]
                    let pt = polarPt.cgpoint
                    let textPt = CGPoint(x: pt.x, y: pt.y)
                    Text(item).rotationEffect(polarPt.cgangle.toAngle(offset: CGFloat.pi/2) + Angle.degrees(textUpsideDown ? 180 : 0)).offset(x: textPt.x, y: textPt.y).font(font).foregroundColor(textColor)
                }
                
            }.frame(width: geo.size.width, height: geo.size.height, alignment: .center)
        }
    }
}

func _setProperty<T>(content: T, _ setBlock:(_ newContent: inout T) -> T) -> T {
    var temp = content
    return setBlock(&temp)
}

extension RingText {
    func setProperty(_ setBlock: (_ text: inout Self) -> Void) -> Self {
        let result = _setProperty(content: self) { (tmp :inout Self) in
            setBlock(&tmp)
            return tmp
        }
        return result
    }
    
    public func textColor(_ color: Color) -> Self {
        setProperty { tmp in
            tmp.textColor = color
        }
    }
    
    public func charSpacing(_ spacing: Double) -> Self {
        setProperty { tmp in
            tmp.char_spacing = spacing
            tmp.textPoints = tmp._createTextPoints()
        }
    }
    
    public func begin(degrees: Double) -> Self {
        return begin(radians: Double(CGAngle.degrees(degrees)))
    }
    
    public func begin(radians: Double) -> Self {
        setProperty { tmp in
            let range = tmp.endRadians - tmp.beginRadians
            tmp.beginRadians = radians
            tmp.endRadians = radians + range
            tmp.char_spacing = (tmp.endRadians - tmp.beginRadians)/Double(tmp.characters.count-1)
            
            tmp.textPoints = tmp._createTextPoints()
        }
    }
    
    public func end(degrees: Double) -> Self {
        return end(radians: Double(CGAngle.degrees(degrees)))
    }
    
    public func end(radians: Double) -> Self {
        setProperty { tmp in
            tmp.endRadians = radians
            tmp.char_spacing = (tmp.endRadians - tmp.beginRadians)/Double(tmp.characters.count-1)
            tmp.textPoints = tmp._createTextPoints()
        }
    }
    
    public func upsideDown(_ yes: Bool) -> Self {
        setProperty { tmp in
            tmp.textUpsideDown = yes
        }
    }
    
    public func reverse(_ yes: Bool) -> Self {
        setProperty { tmp in
            tmp.textReversed = yes
            tmp.characters = _createCharacters(origin: tmp.originwords, reversed: tmp.textReversed)
            tmp.textPoints = tmp._createTextPoints()
        }
    }
    
    public func font(_ f: Font) -> Self {
        setProperty { tmp in
            tmp.font = f
        }
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
struct RingText_Previews: PreviewProvider {
    static var previews: some View {
        RingTextPreviewWrapper()
    }
}

struct RingTextPreviewWrapper: View {
    @State var spacing: Double = 0.3
    @State var begin: Double = 0.0
    @State var end: Double = 360.0
    @State var upside_down: Bool = false
    @State var reverse_text: Bool = false
    @State var begin_0: Double = 0.0
    @State var font_size: Double = 20.0
    var body: some View {
        HStack {
            VStack {
                ZStack {
                    RingText(radius: 40.0, text: "1234567890", color: .blue, upsideDown: true, reversed: true).font(Font.custom("Apple Chancery", size: 16.0)).begin(degrees: begin_0)
                    RingText(radius: 80.0, text: "0987654321", color: .green).font(.system(size: CGFloat(font_size)))
                }
                Text("begin degrees: \(begin_0)")
                Slider(value: $begin_0, in: 0.0...360)
                Text("font size: \(font_size)")
                Slider(value: $font_size, in: 10.0...40.0, step: 1)
            }
            ZStack {
                RingText(radius: 40.0, words: ["a23", "b56", "c89"], reversed: true)
                RingText(radius: 80, words: ["1234567890"])
            }
            VStack {
                ZStack {
                    
                    RingText(radius: 60.0, words: ["12345", "67890"]).begin(degrees: begin)
                        .end(degrees: end)
                        .upsideDown(upside_down)
                        .reverse(reverse_text)
                        .textColor(.red)
                    RingText(radius: 40.0, words: ["1234567890"]).charSpacing(spacing)
                        .upsideDown(upside_down)
                        .reverse(reverse_text)
                        .textColor(.blue)
                    
                }
                VStack(alignment: .leading) {
                    Text("char spacing : \(spacing)")
                    Slider(value: $spacing, in: 0.0...1.0)
                    Text("begin degrees: \(begin)")
                    Slider(value: $begin, in: 0.0...360.0)
                    Text("end degrees: \(end)")
                    Slider(value: $end, in: 0.0...360.0)
                    Toggle("Upside Down", isOn: $upside_down)
                    Toggle("Reverse Text", isOn: $reverse_text)
                }
            }
        }.background(Color.black)
    }
}
