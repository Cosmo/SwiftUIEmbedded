import OpenSwiftUI

struct TupleViewDrawable: Drawable {
    public var origin: Point = Point.zero
    public var size: Size = Size.zero
    
    public var offeredSize: Size = Size.zero
    
    init() {
        
    }
    
    public func wantedWidthForProposal(_ proposedWidth: Int) -> Int {
        return proposedWidth
    }
    
    public func wantedHeightForProposal(_ proposedHeight: Int) -> Int {
        return proposedHeight
    }
}

extension TupleViewDrawable: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "TupleView [\(size)]"
    }
}
