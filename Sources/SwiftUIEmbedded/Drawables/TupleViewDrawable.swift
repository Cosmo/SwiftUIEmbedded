import OpenSwiftUI

struct TupleViewDrawable: Drawable {
    public var origin: Point = Point.zero
    public var size: Size = Size.zero
    
    init() {
        
    }
    
    public func wantedWidthForProposal(_ proposedWidth: Int, otherLength: Int? = nil) -> Int {
        return proposedWidth
    }
    
    public func wantedHeightForProposal(_ proposedHeight: Int, otherLength: Int? = nil) -> Int {
        return proposedHeight
    }
}

extension TupleViewDrawable: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "TupleView [\(size)]"
    }
}
