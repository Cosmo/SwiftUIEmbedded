import Foundation
import OpenSwiftUI

public struct TextDrawable: Drawable {
    public var origin: Point = Point.zero
    public var size: Size = Size.zero
    
    public var offeredSize: Size = Size.zero
    
    public let text: String
    public init(text: String) {
        self.text = text
    }
    
    public func wantedWidthForProposal(_ proposedWidth: Int) -> Int {
        let widthPerGlyph = 12 // 12
        return text.count * widthPerGlyph
    }
    
    public func wantedHeightForProposal(_ proposedHeight: Int) -> Int {
        let heightPerGlyph = 18 // 18
        let textFullWidth = wantedWidthForProposal(Int.max)
        let numberOfLines = Int(ceil(Double(textFullWidth) / Double(size.width)))
        return numberOfLines * heightPerGlyph
    }
}

extension TextDrawable: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "Text [\(origin), \(size)] {text: \(text)}"
    }
}
