import OpenSwiftUI

extension Group: ViewBuildable {
    public func buildDebugTree(tree: inout ViewNode, parent: ViewNode) {
        if let element = _content as? ViewBuildable {
            element.buildDebugTree(tree: &tree, parent: parent)
        }
    }
}
