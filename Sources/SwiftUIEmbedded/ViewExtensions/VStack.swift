import OpenSwiftUI

extension VStack: ViewBuildable {
    public func buildDebugTree(tree: inout ViewNode, parent: ViewNode) {
        let node = ViewNode(value: VStackDrawable())
        parent.addChild(node: node)
        
        ViewExtractor.extractViews(contents: _tree.content).forEach {
            $0.buildDebugTree(tree: &tree, parent: node)
        }
    }
}
