import OpenSwiftUI

extension Color: ViewBuildable {
    public func buildDebugTree(tree: inout Node, parent: Node) {
        parent.addChild(node: Node(value: ColorDrawable(color: self)))
    }
}
