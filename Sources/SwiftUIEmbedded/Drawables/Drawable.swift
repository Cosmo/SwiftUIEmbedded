import OpenSwiftUI

public protocol Drawable: CustomDebugStringConvertible {
    var offeredSize: Size { get set }
    
    var origin: Point { get set }
    var size: Size { get set }
    
    func wantedWidthForProposal(_ proposedWidth: Int) -> Int
    func wantedHeightForProposal(_ proposedHeight: Int) -> Int
}
