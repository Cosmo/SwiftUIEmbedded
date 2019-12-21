import OpenSwiftUI

extension Stepper: ViewBuildable {
    public func buildDebugTree(tree: inout ViewNode, parent: ViewNode) {
        HStack {
            body
            Button(action: onDecrement ?? {}, label: { Text("-").background(Color.gray) })
            Button(action: onIncrement ?? {}, label: { Text("+").background(Color.gray) })
        }.buildDebugTree(tree: &tree, parent: parent)
    }
}
