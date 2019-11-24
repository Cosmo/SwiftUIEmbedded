import OpenSwiftUI

public protocol ViewBuildable {
    func buildDebugTree(tree: inout ViewNode, parent: ViewNode)
}
