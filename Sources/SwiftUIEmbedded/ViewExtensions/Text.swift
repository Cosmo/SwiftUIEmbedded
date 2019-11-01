import OpenSwiftUI

extension Text: ViewBuildable {
    public func buildDebugTree(tree: inout ViewNode, parent: ViewNode) {
        parent.addChild(node: ViewNode(value: TextDrawable(text: _content)))
    }
}
