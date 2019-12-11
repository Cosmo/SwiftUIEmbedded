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
    
    public init(text: String, modifiers: [Text.Modifier]) {
        self.text = text
        self.modifiers = modifiers
    }
    
    public func wantedWidthForProposal(_ proposedWidth: Int, otherLength: Int? = nil) -> Int {
        let height = size.height > 0 ? size.height : otherLength ?? Int.max
        return resolvedFont.font.sizeForText(text, in: (width: proposedWidth, height: height)).width
    }
    
    public func wantedHeightForProposal(_ proposedHeight: Int, otherLength: Int? = nil) -> Int {
        let width = size.width > 0 ? size.width : otherLength ?? Int.max
        return resolvedFont.font.sizeForText(text, in: (width: width, height: proposedHeight)).height
    }
}

extension TextDrawable: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "Text [\(origin), \(size)] {text: \(text), font: \(resolvedFont)}"
    }
}
