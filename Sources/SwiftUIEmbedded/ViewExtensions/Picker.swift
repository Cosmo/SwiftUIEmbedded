import OpenSwiftUI

extension Picker: ViewBuildable {
    public func buildDebugTree(tree: inout ViewNode, parent: ViewNode) {
        VStack {
            self.body
        }.buildDebugTree(tree: &tree, parent: parent)
    }
}
