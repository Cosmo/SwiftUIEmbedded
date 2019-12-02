import OpenSwiftUI

struct VStackDrawable: Drawable {
    public var origin: Point = Point.zero
    public var size: Size = Size.zero
    
    public var alignment: HorizontalAlignment
    
    init(alignment: HorizontalAlignment) {
        self.alignment = alignment
    }
    
    public func wantedWidthForProposal(_ proposedWidth: Int, otherLength: Int? = nil) -> Int {
        return proposedWidth
    }
    
    public func wantedHeightForProposal(_ proposedHeight: Int, otherLength: Int? = nil) -> Int {
        return proposedHeight
    }
}

extension VStackDrawable: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "VStack [\(origin), \(size)]"
    }
}
