import OpenSwiftUI

extension TupleView: ViewBuildable {
    public func buildDebugTree(tree: inout ViewNode, parent: ViewNode) {
        for child in Mirror(reflecting: value).children {
            if let viewBuildable = child.value as? ViewBuildable {
                viewBuildable.buildDebugTree(tree: &tree, parent: parent)
            } else {
                // child as View
                print("Can't render custom views, yet.")
            }
        }
    }
}
