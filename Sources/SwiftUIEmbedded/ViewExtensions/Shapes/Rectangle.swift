import OpenSwiftUI

extension Rectangle: ViewBuildable {
    public func buildDebugTree(tree: inout ViewNode, parent: ViewNode) {
        parent.addChild(node: ViewNode(value: RectangleDrawable()))
    }
}
