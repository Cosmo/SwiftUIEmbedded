import OpenSwiftUI

public struct DividerDrawable: Drawable {
    public var origin: Point = Point.zero
    public var size: Size = Size.zero
    
    public var axis: Axis
    
    public init(axis: Axis) {
        self.axis = axis
    }
    
    public func wantedWidthForProposal(_ proposedWidth: Int, otherLength: Int? = nil) -> Int {
        if axis == .horizontal {
            return proposedWidth
        } else {
            return 1
        }
    }
    
    public func wantedHeightForProposal(_ proposedHeight: Int, otherLength: Int? = nil) -> Int {
        if axis == .vertical {
            return proposedHeight
        } else {
            return 1
        }
    }
}

extension DividerDrawable: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "Divider [\(size), \(origin)]"
    }
}
