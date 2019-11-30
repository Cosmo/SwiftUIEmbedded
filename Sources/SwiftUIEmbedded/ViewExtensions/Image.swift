import OpenSwiftUI

extension Image: ViewBuildable {
    public func buildDebugTree(tree: inout ViewNode, parent: ViewNode) {
        if let provider = _provider as? ImageDataProvider {
            let imageData = provider.imageData
            parent.addChild(node: ViewNode(value: ImageDrawable(imageData: imageData)))
        } else {
            print("Unknown Image")
        }
    }
}

public class ImageDataProvider: AnyImageProviderBox {
    public var imageData: ImageData
    
    init(imageData: ImageData) {
        self.imageData = imageData
        super.init()
    }
}

extension Image {
    public init(imageData: ImageData) {
        self = Image(provider: ImageDataProvider(imageData: imageData))
    }
}

public struct ImageData: Equatable {
    public var bytes: [UInt8]
    public var size: Size
    
    public init(bytes: [UInt8], size: Size) {
        self.bytes = bytes
        self.size = size
    }
}
