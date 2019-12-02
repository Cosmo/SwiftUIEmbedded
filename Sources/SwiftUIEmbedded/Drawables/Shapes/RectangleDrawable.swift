import OpenSwiftUI

public struct RectangleDrawable: Drawable {
    public var origin: Point = Point.zero
    public var size: Size = Size.zero
    
    public init() {
        
    }
    
    public func wantedWidthForProposal(_ proposedWidth: Int, otherLength: Int? = nil) -> Int {
        return proposedWidth
    }
    
    public func wantedHeightForProposal(_ proposedHeight: Int, otherLength: Int? = nil) -> Int {
        return proposedHeight
    }
}

extension RectangleDrawable: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "Rectangle [\(size)]"
    }
}
