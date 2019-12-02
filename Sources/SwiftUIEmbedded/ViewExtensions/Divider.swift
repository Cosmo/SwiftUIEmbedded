import OpenSwiftUI

extension Divider: ViewBuildable {
    public func buildDebugTree(tree: inout ViewNode, parent: ViewNode) {
        let axisValue = axis(ancestors: parent.ancestorsIncludingSelf)
        parent.addChild(node: ViewNode(value: DividerDrawable(axis: axisValue)))
    }
    
    private func axis(ancestors: [ViewNode]) -> Axis {
        let ancestor = ancestors.first(where: { $0.value is RootDrawable || $0.value is ZStackDrawable || $0.value is HStackDrawable || $0.value is VStackDrawable })
        
        if let ancestor = ancestor, ancestor.value is HStackDrawable {
            return .vertical
        } else {
            return .horizontal
        }
    }
}
