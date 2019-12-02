import OpenSwiftUI

struct ZStackDrawable: Drawable {
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

extension ZStackDrawable: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "ZStack [\(origin), \(size)]"
    }
}
