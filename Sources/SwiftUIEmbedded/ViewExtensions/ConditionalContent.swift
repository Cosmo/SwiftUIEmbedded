import OpenSwiftUI

extension _ConditionalContent: ViewBuildable {
    public func buildDebugTree(tree: inout ViewNode, parent: ViewNode) {
        switch _storage {
        case .first(let content):
            if let element = content as? ViewBuildable {
                element.buildDebugTree(tree: &tree, parent: parent)
            } else {
                print("Non-ViewBuildable detected. \(content)", #function)
            }
        case .second(let content):
            if let element = content as? ViewBuildable {
                element.buildDebugTree(tree: &tree, parent: parent)
            } else {
                print("Non-ViewBuildable detected. \(content)", #function)
            }
        }
    }
}
