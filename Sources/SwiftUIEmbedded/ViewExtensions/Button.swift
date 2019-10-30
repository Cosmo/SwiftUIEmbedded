import OpenSwiftUI

extension Button: ViewBuildable {
    public func buildDebugTree(tree: inout Node, parent: Node) {
        let node = Node(value: ButtonDrawable())
        parent.addChild(node: node)
        
        if let element = _label as? ViewBuildable {
            element.buildDebugTree(tree: &tree, parent: node)
        }
    }
}
