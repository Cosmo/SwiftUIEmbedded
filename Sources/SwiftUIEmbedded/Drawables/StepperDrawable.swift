import OpenSwiftUI

struct StepperDrawable: Drawable {
    public var origin: Point = Point.zero
    public var size: Size = Size.zero
    
    public var onIncrement: (() -> Void)?
    public var onDecrement: (() -> Void)?
    public var onEditingChanged: (Bool) -> Void
    
    init(onIncrement: (() -> Void)?, onDecrement: (() -> Void)?, onEditingChanged: @escaping (Bool) -> Void) {
        self.onIncrement = onIncrement
        self.onDecrement = onDecrement
        self.onEditingChanged = onEditingChanged
    }
    
    public func wantedWidthForProposal(_ proposedWidth: Int, otherLength: Int? = nil) -> Int {
        return proposedWidth
    }
    
    public func wantedHeightForProposal(_ proposedHeight: Int, otherLength: Int? = nil) -> Int {
        return proposedHeight
    }
}

extension StepperDrawable: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "Stepper [\(size)]"
    }
}
