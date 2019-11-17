import OpenSwiftUI

extension ForEach: ViewBuildable {
    public func buildDebugTree(tree: inout ViewNode, parent: ViewNode) {
        data.forEach { body in
            if let element = content(body) as? ViewBuildable {
                element.buildDebugTree(tree: &tree, parent: parent)
            }
        }
    }
}
