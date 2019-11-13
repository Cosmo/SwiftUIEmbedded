import OpenSwiftUI

extension ZStack: ViewBuildable {
    public func buildDebugTree(tree: inout ViewNode, parent: ViewNode) {
        let node = ViewNode(value: ZStackDrawable())
        parent.addChild(node: node)
        
        ViewExtractor.extractViews(contents: _tree.content).forEach {
            $0.buildDebugTree(tree: &tree, parent: node)
        }
    }
}
