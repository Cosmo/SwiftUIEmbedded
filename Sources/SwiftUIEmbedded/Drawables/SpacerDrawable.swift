import OpenSwiftUI

public struct SpacerDrawable: Drawable {
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

extension SpacerDrawable: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "Spacer [\(size)]"
    }
}
