import OpenSwiftUI

internal struct ViewExtractor<Content>: View where Content: View {
    internal static func extractViews(contents: Content) -> [ViewBuildable] {
        var buildables = [ViewBuildable]()
        
        if let element = contents as? ViewBuildable {
            buildables.append(element)
        } else if let element = contents.body as? ViewBuildable {
            // Custom View
            buildables.append(element)
        } else {
            print(contents)
            print("No Idea what's inside.")
        }
        
        return buildables
    }
}

extension ViewExtractor {
    internal var body: Never {
        fatalError()
    }
}
