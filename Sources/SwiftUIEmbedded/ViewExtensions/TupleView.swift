import OpenSwiftUI

extension TupleView: ViewBuildable {
    public func buildDebugTree(tree: inout ViewNode, parent: ViewNode) {
        Mirror(reflecting: value).children.compactMap {
            $0.value as? ViewBuildable
        }.forEach {
            $0.buildDebugTree(tree: &tree, parent: parent)
        }
    }
}
