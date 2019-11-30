import OpenSwiftUI

extension AnyView: ViewBuildable {
    public func buildDebugTree(tree: inout ViewNode, parent: ViewNode) {
        if let view = Mirror(reflecting: _storage).children.first?.value as? ViewBuildable {
            view.buildDebugTree(tree: &tree, parent: parent)
        }
    }
}
