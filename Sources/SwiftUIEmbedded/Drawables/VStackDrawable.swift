import OpenSwiftUI

struct VStackDrawable: Drawable {
    public var origin: Point = Point.zero
    public var size: Size = Size.zero
    
    init() {
        
    }
    
    public func wantedWidthForProposal(_ proposedWidth: Int) -> Int {
        return proposedWidth
    }
    
    public func wantedHeightForProposal(_ proposedHeight: Int) -> Int {
        return proposedHeight
    }
}

extension VStackDrawable: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "VStack [\(size)]"
    }
}
