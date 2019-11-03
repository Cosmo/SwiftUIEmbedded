import Foundation
import OpenSwiftUI

public struct TextDrawable: Drawable {
    public var origin: Point = Point.zero
    public var size: Size = Size.zero
    
    public let text: String
    public let font: Font
    public let color: Color
    
    public init(text: String, font: Font, color: Color) {
        self.text = text
        self.font = font
        self.color = color
    }
    
    public func wantedWidthForProposal(_ proposedWidth: Int) -> Int {
        let widthPerGlyph = 6 * font.fontSizeToZoomLevel
        return text.count * widthPerGlyph
    }
    
    public func wantedHeightForProposal(_ proposedHeight: Int) -> Int {
        let heightPerGlyph = 9 * font.fontSizeToZoomLevel
        let textFullWidth = wantedWidthForProposal(Int.max)
        let numberOfLines = Int(ceil(Double(textFullWidth) / Double(size.width)))
        return numberOfLines * Int(heightPerGlyph)
    }
}

extension Font {
    var fontSizeToZoomLevel: Int {
        let bitmapFontSize = 8
        return max(Int(size) / bitmapFontSize, 1)
    }
}

extension TextDrawable: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "Text [\(origin), \(size)] {text: \(text), font: \(font)}"
    }
}
