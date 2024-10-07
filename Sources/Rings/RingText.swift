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
                sizes = value
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
