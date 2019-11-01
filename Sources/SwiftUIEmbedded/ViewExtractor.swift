import OpenSwiftUI

internal struct ViewExtractor<Content>: View where Content: View {
    internal static func extractViews(contents: Content) -> [ViewBuildable] {
        var buildables = [ViewBuildable]()
        
        let contentMirror = Mirror(reflecting: contents)
        let isTupleView = String(describing: contentMirror.subjectType).starts(with: "TupleView")
        
        if isTupleView, let tupleValue = contentMirror.children.first(where: { $0.label == "value" })?.value {
            // Multiple Views
            // FIXME: Ignores custom views inside of a TupleView
            Mirror(reflecting: tupleValue).children.compactMap {
                $0.value as? ViewBuildable
            }.forEach {
                buildables.append($0)
            }
        } else if let element = contents as? ViewBuildable {
            // Single View
            buildables.append(element)
        } else if let element = contents.body as? ViewBuildable {
            // Custom View
            buildables.append(element)
        } else {
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
