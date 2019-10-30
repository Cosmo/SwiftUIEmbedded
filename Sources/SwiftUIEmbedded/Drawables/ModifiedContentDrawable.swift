import OpenSwiftUI

public struct ModifiedContentDrawable<Modifier>: Drawable {
    public var origin: Point = Point.zero
    public var size: Size = Size.zero
    
    let modifier: Modifier
    
    public init(modifier: Modifier) {
        self.modifier = modifier
    }
    
    public func wantedWidthForProposal(_ proposedWidth: Int) -> Int {
        return proposedWidth
    }
    
    public func wantedHeightForProposal(_ proposedHeight: Int) -> Int {
        return proposedHeight
    }
}

extension ModifiedContentDrawable: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "ModifiedContent [\(size)] {\(modifier)}"
    }
}
