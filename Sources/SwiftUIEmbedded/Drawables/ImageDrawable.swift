import OpenSwiftUI

public struct ImageDrawable: Drawable {
    public var origin: Point = Point.zero
    public var size: Size = Size.zero
    
    public var bitmap: Bitmap
    
    public init(bitmap: Bitmap) {
        self.bitmap = bitmap
    }
    
    public func wantedWidthForProposal(_ proposedWidth: Int, otherLength: Int? = nil) -> Int {
        return bitmap.size.width
    }
    
    public func wantedHeightForProposal(_ proposedHeight: Int, otherLength: Int? = nil) -> Int {
        return bitmap.size.height
    }
}

extension ImageDrawable: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "Image [\(origin), \(size)]"
    }
}
