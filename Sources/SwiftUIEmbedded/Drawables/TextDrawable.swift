import Foundation
import OpenSwiftUI

public struct TextDrawable: Drawable {
    public var origin: Point = Point.zero
    public var size: Size = Size.zero
    
    public let text: String
    public let modifiers: [Text.Modifier]

    public var resolvedFont: Font {
        var result: Font?
        for modifier in modifiers {
            switch modifier {
            case .font(let font):
                result = font
            default:
                continue
            }
        }
        
        return result ?? Font.body
    }
    
    public var resolvedColor: Color {
        var result: Color?
        for modifier in modifiers {
            switch modifier {
            case .color(let color):
                result = color
            default:
                continue
            }
        }
        
        return result ?? Color.black
    }
    
    public init(text: String, modifiers: [Text.Modifier]) {
        self.text = text
        self.modifiers = modifiers
    }
    
    public func wantedWidthForProposal(_ proposedWidth: Int) -> Int {
        let widthPerGlyph = 6 * resolvedFont.fontSizeToZoomLevel
        let width = text.count * widthPerGlyph
        return width
    }
    
    public func wantedHeightForProposal(_ proposedHeight: Int) -> Int {
        let heightPerGlyph = 9 * resolvedFont.fontSizeToZoomLevel
        let textFullWidth = wantedWidthForProposal(Int.max)
        let numberOfLines = Int(ceil(Double(textFullWidth) / Double(size.width)))
        let height = numberOfLines * Int(heightPerGlyph)
        return height
    }
}

extension TextDrawable: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "Text [\(origin), \(size)] {text: \(text), font: \(resolvedFont)}"
    }
}
