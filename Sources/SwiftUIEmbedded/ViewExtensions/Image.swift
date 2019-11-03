import OpenSwiftUI

extension Image: ViewBuildable {
    public func buildDebugTree(tree: inout ViewNode, parent: ViewNode) {
        parent.addChild(node: ViewNode(value: ImageDrawable(imageData: _imageData)))
    }
}
