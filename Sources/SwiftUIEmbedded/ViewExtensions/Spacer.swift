import OpenSwiftUI

extension Spacer: ViewBuildable {
    public func buildDebugTree(tree: inout Node, parent: Node) {
        parent.addChild(node: Node(value: SpacerDrawable()))
    }
}
