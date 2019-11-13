import OpenSwiftUI

public struct ImageDrawable: Drawable {
    public var origin: Point = Point.zero
    public var size: Size = Size.zero
    
    public var imageData: ImageData
    
    public init(imageData: ImageData) {
        self.imageData = imageData
    }
    
    public func wantedWidthForProposal(_ proposedWidth: Int) -> Int {
        return imageData.size.width
    }
    
    public func wantedHeightForProposal(_ proposedHeight: Int) -> Int {
        return imageData.size.height
    }
}

extension ImageDrawable: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "Image [\(origin), \(size)]"
    }
}
