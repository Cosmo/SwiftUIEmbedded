import OpenSwiftUI

extension Circle: ViewBuildable {
    public func buildDebugTree(tree: inout Node, parent: Node) {
        parent.addChild(node: Node(value: CircleDrawable()))
    }
}
