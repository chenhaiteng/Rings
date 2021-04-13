import SwiftUI
import CoreGraphicsExtension

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public extension CGAngle {
    func toAngle(offset radians: CGFloat = 0.0) -> Angle {
        Angle(radians: Double(self.radians + radians))
    }
}


private func _createStringTable(origin: [String], reversed:Bool = false) -> [(Int, String)] {
    var tmpWords = reversed ? origin.reversed() : origin
    
    if(reversed) {
        tmpWords = tmpWords.map({ word -> String in
            String(word.reversed())
        })
    }
    
    let text = (tmpWords.count == 1) ? tmpWords[0] : tmpWords.reduce(String()) { result, element -> String in
        result + element + " "
    }
    
    let characters = Array(text.enumerated()).map { (e: EnumeratedSequence<String>.Iterator.Element) -> (Int, String) in
        (e.offset, String(e.element))
    }
    return characters
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct RingText : View {
    var radius: Double
    var textSize: CGFloat
    var textColor: Color
    var textUpsideDown: Bool
    var textReversed: Bool
    
    var char_spacing: Double
    var beginRadians: Double
    var endRadians: Double
    private var stringTable: [(offset: Int, element:String)]
    private var textPoints: [CGPolarPoint] = []
    
    public init(radius: Double, words: [String], textSize:CGFloat = 20.0, color: Color = Color.white, upsideDown: Bool = false, reversed: Bool = false, begin: CGAngle = CGAngle.zero, end: CGAngle? = nil) {
        self.radius = radius
        self.textColor = color
        self.textSize = textSize
        self.textUpsideDown = upsideDown
        self.textReversed = reversed
        
        stringTable = _createStringTable(origin: words, reversed: reversed)
        
        beginRadians = Double(begin.radians)
        
        let count = stringTable.count-1
        let ratio = CGFloat(count)/CGFloat(stringTable.count)
        
        endRadians = Double(end?.radians ?? 2*CGFloat.pi*ratio+begin.radians)
        
        char_spacing = (endRadians - beginRadians)/Double(count)
        
        textPoints = _createTextPoints()
    }
    
    public init(radius: Double, text: String, textSize:CGFloat = 20.0, color: Color = Color.white, upsideDown: Bool = false, reversed: Bool = false, begin: CGAngle = CGAngle.zero) {
        self.init(radius: radius, words: [text], textSize: textSize, color: color, upsideDown: upsideDown, reversed: reversed, begin: begin)
    }
    
    private func _createTextPoints() -> [CGPolarPoint] {
        return stringTable.map({ (offset: Int, element: String) -> CGPolarPoint in
            return CGPolarPoint(radius: radius, angle: CGAngle( beginRadians + char_spacing * Double(offset)))
        })
    }
    
    public var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(stringTable, id: \.self.offset) { (offset, element) in
                    let pt = self.textPoints[offset].cgpoint
                    let textPt = CGPoint(x: pt.x, y: pt.y)
                    Text(element)
                        .rotationEffect(self.textPoints[offset].cgangle.toAngle(offset: CGFloat.pi/2) +   Angle.degrees(textUpsideDown  ? 180 : 0))
                        .offset(x: textPt.x, y: textPt.y)
                        .font(.system(size: textSize)).foregroundColor(textColor)
                    
                }
            }.frame(width: geo.size.width, height: geo.size.height, alignment: .center)
        }
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
struct RingText_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ZStack {
                RingText(radius: 20.0, text: "1234567890",textSize: 16.0, color: .red, upsideDown: false, begin: -CGAngle.pi/2)
                RingText(radius: 50.0, text: "1234567890",textSize: 20.0, color: .blue, upsideDown: true, reversed: true)
                RingText(radius: 90.0, text: "0987654321",textSize: 32.0, color: .green)
            }
            ZStack {
                RingText(radius: 40.0, words: ["123", "456", "789"])
                RingText(radius: 80, words: ["1234567890"])
            }
            ZStack {
                RingText(radius: 80.0, words: ["123456789"], textSize: 16.0, color: .red, upsideDown: false, reversed: false, begin: CGAngle.degrees(-180), end: CGAngle.zero)
            }
        }.background(Color.black)
    }
}
