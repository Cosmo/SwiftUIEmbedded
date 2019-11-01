import OpenSwiftUI

extension Button: ViewBuildable {
    public func buildDebugTree(tree: inout ViewNode, parent: ViewNode) {
        let node = ViewNode(value: ButtonDrawable())
        parent.addChild(node: node)
        
        if let element = _label as? ViewBuildable {
            element.buildDebugTree(tree: &tree, parent: node)
        }
    }
}
