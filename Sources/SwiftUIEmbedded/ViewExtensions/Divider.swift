import OpenSwiftUI

extension Divider: ViewBuildable {
    public func buildDebugTree(tree: inout ViewNode, parent: ViewNode) {
        parent.addChild(node: ViewNode(value: DividerDrawable(axis: axis(ancestors: parent.ancestorsIncludingSelf))))
    }
    
    private func axis(ancestors: [ViewNode]) -> Axis {
        let ancestor = ancestors.first(where: { $0.value is VStackDrawable || $0.value is RootDrawable || $0.value is HStackDrawable })
        
        if let ancestor = ancestor, ancestor.value is HStackDrawable {
            return .vertical
        } else {
            return .horizontal
        }
    }
}
