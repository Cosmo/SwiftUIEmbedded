import OpenSwiftUI

extension ButtonStyleConfiguration.Label: ViewBuildable {
    public func buildDebugTree(tree: inout ViewNode, parent: ViewNode) {
        if let view = Mirror(reflecting: _storage).children.first?.value as? ViewBuildable {
            view.buildDebugTree(tree: &tree, parent: parent)
        }
    }
}

extension Button: ViewBuildable {
    public func buildDebugTree(tree: inout ViewNode, parent: ViewNode) {
        let node = ViewNode(value: ButtonDrawable(action: _action))
        parent.addChild(node: node)
        if let element = _label as? ViewBuildable {
            element.buildDebugTree(tree: &tree, parent: node)
        }
    }
}
