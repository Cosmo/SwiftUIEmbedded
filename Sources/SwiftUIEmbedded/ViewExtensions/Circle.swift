import OpenSwiftUI

extension Circle: ViewBuildable {
    public func buildDebugTree(tree: inout ViewNode, parent: ViewNode) {
        parent.addChild(node: ViewNode(value: CircleDrawable()))
    }
}
