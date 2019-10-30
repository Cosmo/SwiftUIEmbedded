import OpenSwiftUI

extension Text: ViewBuildable {
    public func buildDebugTree(tree: inout Node, parent: Node) {
        parent.addChild(node: Node(value: TextDrawable(text: _content)))
    }
}
