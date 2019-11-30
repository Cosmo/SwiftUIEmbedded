import OpenSwiftUI

extension Divider: ViewBuildable {
    public func buildDebugTree(tree: inout ViewNode, parent: ViewNode) {
        parent.addChild(node: ViewNode(value: DividerDrawable()))
    }
}
