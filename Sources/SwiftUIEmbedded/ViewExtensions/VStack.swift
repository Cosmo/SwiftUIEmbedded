import OpenSwiftUI

extension VStack: ViewBuildable {
    public func buildDebugTree(tree: inout Node, parent: Node) {
        let node = Node(value: VStackDrawable())
        parent.addChild(node: node)
        
        let contentMirror = Mirror(reflecting: _content)
        if String(describing: contentMirror.subjectType).starts(with: "TupleView") {
            let (_, tupleValue) = contentMirror.children.first!
            let tupleMirror = Mirror(reflecting: tupleValue)
            
            for (_, element) in tupleMirror.children {
                if let element = element as? ViewBuildable {
                    element.buildDebugTree(tree: &tree, parent: node)
                }
            }
        } else if let element = _content as? ViewBuildable {
            element.buildDebugTree(tree: &tree, parent: node)
        } else {
            print("WTF?: \(String(describing: contentMirror.subjectType))")
        }
    }
}
