import OpenSwiftUI

public struct ColorDrawable: Drawable {
    public var origin: Point = Point.zero
    public var size: Size = Size.zero
    
    let color: Color
    
    public init(color: Color) {
        self.color = color
    }
    
    public func wantedWidthForProposal(_ proposedWidth: Int, otherLength: Int? = nil) -> Int {
        return proposedWidth
    }
    
    public func wantedHeightForProposal(_ proposedHeight: Int, otherLength: Int? = nil) -> Int {
        return proposedHeight
    }
}

extension ColorDrawable: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "Color [\(size)] {color: \(color)}"
    }
}
