import OpenSwiftUI

extension TupleView: ViewBuildable {
    public func buildDebugTree(tree: inout Node, parent: Node) {
        parent.addChild(node: Node(value: TupleViewDrawable()))
    }
}

