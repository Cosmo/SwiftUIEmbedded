import OpenSwiftUI

extension Image: ViewBuildable {
    public func buildDebugTree(tree: inout ViewNode, parent: ViewNode) {
        if let provider = _provider as? BitmapImageProvider {
            let bitmap = provider.bitmap
            parent.addChild(node: ViewNode(value: ImageDrawable(bitmap: bitmap)))
        } else {
            print("Unknown Image")
        }
    }
}

public class BitmapImageProvider: AnyImageProviderBox {
    public var bitmap: Bitmap
    
    init(bitmap: Bitmap) {
        self.bitmap = bitmap
        super.init()
    }
}

extension Image {
    public init(bitmap: Bitmap) {
        self = Image(provider: BitmapImageProvider(bitmap: bitmap))
    }
}

public struct Bitmap: Equatable {
    public var bytes: [UInt8]
    public var size: Size
    
    public init(bytes: [UInt8], size: Size) {
        self.bytes = bytes
        self.size = size
    }
}
