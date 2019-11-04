import OpenSwiftUI

extension _ConditionalContent: ViewBuildable {
    public func buildDebugTree(tree: inout ViewNode, parent: ViewNode) {
        switch _storage {
        case .trueContent(let content):
            if let element = content as? ViewBuildable {
                element.buildDebugTree(tree: &tree, parent: parent)
            } else {
                print("Non-ViewBuildable detected. \(content)", #function)
            }
        case .falseContent(let content):
            if let element = content as? ViewBuildable {
                element.buildDebugTree(tree: &tree, parent: parent)
            } else {
                print("Non-ViewBuildable detected. \(content)", #function)
            }
        }
    }
}
