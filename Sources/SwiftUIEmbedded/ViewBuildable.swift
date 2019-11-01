import OpenSwiftUI

public protocol ViewBuildable {
    func buildDebugTree(tree: inout Node, parent: Node)
}
