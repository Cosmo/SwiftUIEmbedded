import OpenSwiftUI

extension Spacer: ViewBuildable {
    public func buildDebugTree(tree: inout ViewNode, parent: ViewNode) {
        parent.addChild(node: ViewNode(value: SpacerDrawable()))
    }
}
