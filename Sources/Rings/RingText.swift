import SwiftUI
import CoreGraphicsExtension

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public extension CGAngle {
    func toAngle(offset radians: CGFloat = 0.0) -> Angle {
        Angle(radians: Double(self.radians + radians))
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct RingText : View {
    var radius: Double
    var textSize: CGFloat
    var textColor: Color
    var textUpsideDown: Bool
    var textReversed: Bool
    private var stringTable: [(offset: Int, element:String)]
    private var textPoints: [CGPolarPoint]
    
    public init(radius: Double, words: [String], textSize:CGFloat = 20.0, color: Color = Color.white, upsideDown: Bool = false, reversed: Bool = false, begin: CGAngle = CGAngle.zero, end: CGAngle? = nil) {
        self.radius = radius
        self.textColor = color
        self.textSize = textSize
        self.textUpsideDown = upsideDown
        self.textReversed = reversed
        
        let text = (words.count == 1) ? words[0] : words.reduce(String()) { result, element -> String in
            result + element + " "
        }
        
        let characters = Array(text.enumerated()).map { (e: EnumeratedSequence<String>.Iterator.Element) -> (Int, String) in
            (e.offset, String(e.element))
        }
        
        self.stringTable = characters
        let beginOffset = Double(begin.radians)
        if let endOffset = end?.radians, let range = (endOffset - begin.radians) as? CGFloat, range > 0 {
            let gap = (textReversed ? -1.0 : 1.0)*Double(range)/Double(stringTable.count-1)
            textPoints = self.stringTable.map({ (offset: Int, element: String) -> CGPolarPoint in
                return CGPolarPoint(radius: radius, angle: CGAngle( beginOffset + gap * Double(offset)))
            })
        } else {
            let gap = (textReversed ? -2.0 : 2.0)*Double.pi/Double(stringTable.count)
            textPoints = self.stringTable.map({ (offset: Int, element: String) -> CGPolarPoint in
                return CGPolarPoint(radius: radius, angle: CGAngle( beginOffset + gap * Double(offset)))
            })
        }
    }
    
    public init(radius: Double, text: String, textSize:CGFloat = 20.0, color: Color = Color.white, upsideDown: Bool = false, reversed: Bool = false, begin: CGAngle = CGAngle.zero) {
        self.init(radius: radius, words: [text], textSize: textSize, color: color, upsideDown: upsideDown, reversed: reversed, begin: begin)
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
