import OpenSwiftUI

extension ZStack: ViewBuildable {
    public func buildDebugTree(tree: inout Node, parent: Node) {
        let node = Node(value: ZStackDrawable())
        parent.addChild(node: node)
        
        ViewExtractor.extractViews(contents: _content).forEach {
            $0.buildDebugTree(tree: &tree, parent: node)
        }
    }
}
