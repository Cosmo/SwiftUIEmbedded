import OpenSwiftUI

public struct DividerDrawable: Drawable {
    public var origin: Point = Point.zero
    public var size: Size = Size.zero
    
    private let axis: Axis
    
    public init(axis: Axis) {
        self.axis = axis
    }
    
    public func wantedWidthForProposal(_ proposedWidth: Int) -> Int {
        if axis == .horizontal {
            return proposedWidth
        } else {
            return 10
        }
    }
    
    public func wantedHeightForProposal(_ proposedHeight: Int) -> Int {
        if axis == .vertical {
            return proposedHeight
        } else {
            return 10
        }
    }
}

extension DividerDrawable: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "Divider [\(size), \(origin)]"
    }
}
