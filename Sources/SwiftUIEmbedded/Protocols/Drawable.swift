import OpenSwiftUI

public protocol Drawable: CustomDebugStringConvertible {
    var origin: Point { get set }
    var size: Size { get set }
    
    func wantedWidthForProposal(_ proposedWidth: Int, otherLength: Int?) -> Int
    func wantedHeightForProposal(_ proposedHeight: Int, otherLength: Int?) -> Int
    
    var passthrough: Bool { get }
}

extension Drawable {
    public var passthrough: Bool {
        return false
    }
}
