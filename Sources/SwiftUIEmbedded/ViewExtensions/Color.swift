import OpenSwiftUI

extension Color: ViewBuildable {
    public func buildDebugTree(tree: inout ViewNode, parent: ViewNode) {
        parent.addChild(node: ViewNode(value: ColorDrawable(color: self)))
    }
}
