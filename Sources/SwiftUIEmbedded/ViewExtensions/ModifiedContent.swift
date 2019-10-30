import OpenSwiftUI

extension ModifiedContent: ViewBuildable {
    public func buildDebugTree(tree: inout Node, parent: Node) {
        let node = Node(value: ModifiedContentDrawable(modifier: modifier))
        parent.addChild(node: node)
        
        if let element = content as? ViewBuildable {
            element.buildDebugTree(tree: &tree, parent: node)
        }
    }
}
