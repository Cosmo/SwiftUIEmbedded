import OpenSwiftUI

struct HStackDrawable: Drawable {
    public var origin: Point = Point.zero
    public var size: Size = Size.zero
    
    public var alignment: VerticalAlignment
    
    init(alignment: VerticalAlignment) {
        self.alignment = alignment
    }
    
    public func wantedWidthForProposal(_ proposedWidth: Int, otherLength: Int? = nil) -> Int {
        return proposedWidth
    }
    
    public func wantedHeightForProposal(_ proposedHeight: Int, otherLength: Int? = nil) -> Int {
        return proposedHeight
    }
}

extension HStackDrawable: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "HStack [\(origin), \(size)]"
    }
}
