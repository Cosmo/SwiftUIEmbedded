import OpenSwiftUI

/// Credits: Chris Eidhof / objc.io
/// https://www.objc.io/blog/2019/10/29/swiftui-environment/

public struct DumpingEnvironment<V: View>: View {
    @Environment(\.self) var env
    public let content: V
    public var body: some View {
        dump(env)
        return content
    }
    
    public init(content: V) {
        self.content = content
    }
}

extension DumpingEnvironment {
    public func buildDebugTree(tree: inout ViewNode, parent: ViewNode) {
        let node = ViewNode(value: DumpingEnvironmentDrawable())
        parent.addChild(node: node)
        
        if let element = content as? ViewBuildable {
            element.buildDebugTree(tree: &tree, parent: node)
        }
    }
}

public struct DumpingEnvironmentDrawable: Drawable {
    public var origin: Point = Point.zero
    
    public var size: Size = Size.zero
    
    public func wantedWidthForProposal(_ proposedWidth: Int, otherLength: Int? = nil) -> Int {
        return proposedWidth
    }
    
    public func wantedHeightForProposal(_ proposedHeight: Int, otherLength: Int? = nil) -> Int {
        return proposedHeight
    }
    
    public var debugDescription: String {
        return "DumpingEnvironment"
    }
}
