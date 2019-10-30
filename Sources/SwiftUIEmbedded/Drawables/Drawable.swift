import OpenSwiftUI

public protocol Drawable: CustomDebugStringConvertible {
    var origin: Point { get set }
    var size: Size { get set }
    
    func wantedWidthForProposal(_ proposedWidth: Int) -> Int
    func wantedHeightForProposal(_ proposedHeight: Int) -> Int
}
