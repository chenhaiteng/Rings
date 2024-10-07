//
//  GaugeMeter.swift
//
//
//  Created by Chen Hai Teng on 1/31/24.
//

import SwiftUI
import Common
import CoreGraphics
import CoreGraphicsExtension
import SequenceBuilder

/// A gauge meter is use to display value.
public struct GaugeMeter<Layers:Sequence>: View where Layers.Element: AngularLayer {
    private var layers: Layers
    
    private var mappingObj: KnobMapping
    
    public var offset: CGPoint = .zero
    private var radius: Double
    private var value: Double
    
    @State private var startValue: Double = .nan
    
    /// Create a gauge meter to diplay value with the given radius, mapping relation between value and degree, and components to compose it.
    /// - Parameters:
    ///   - value: The value to show in gauge meter.
    ///   - radius: The radius of the gauge meter, default is 100.0.
    ///   - mapping: The mapping object to transform value to degree. The default mapping will map the value in 0...1.0 into degrees -180.0...0.0 linearly.
    ///   - components: A builder which building the layers to compose the gague meter.
    public init<F:BinaryFloatingPoint>(value: F, radius: Double = 100.0, mapping: KnobMapping = LinearMapping(degreeRange: -180.0...0.0), @SequenceBuilder _ components: ()->Layers) {
        self.radius = radius
        self.value = Double(value)
        mappingObj = mapping
        layers = components()
    }
    
    public var body: some View {
        ZStack(alignment: .center) {
            ForEach(sequence: layers) { (index, layer) in
                layer.mappingValue(value, with: mappingObj).radius(radius).offset(dx: offset.x, dy: offset.y).body.frame(width: radius * 2.0, height: radius * 2.0)
            }
        }
    }
}

extension GaugeMeter: Adjustable {
    /// Offset the gauge meter by the horizontal and vertical amount.
    /// - Parameters:
    ///   - dx: The horizontal distance to offset.
    ///   - dy: The vertical distance to offset.
    /// - Returns: A gauage meter that offsets itself by x and y.
    func offset<F: BinaryFloatingPoint>(dx:F = 0.0, dy:F = 0.0) -> Self {
        setProperty { adjustObject in
            adjustObject.offset = CGPoint(x: Double(dx), y: Double(dy))
        }
    }
}


