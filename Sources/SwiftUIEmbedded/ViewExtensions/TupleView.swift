import OpenSwiftUI

extension TupleView: ViewBuildable {
    public func buildDebugTree(tree: inout ViewNode, parent: ViewNode) {
        parent.addChild(node: ViewNode(value: TupleViewDrawable()))
    }
}

