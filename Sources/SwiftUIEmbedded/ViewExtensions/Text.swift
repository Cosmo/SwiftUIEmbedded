import OpenSwiftUI
import CoreGraphics

extension Text: ViewBuildable {
    public func buildDebugTree(tree: inout ViewNode, parent: ViewNode) {
        switch _storage {
        case .verbatim(let content):
            parent.addChild(node: ViewNode(value: TextDrawable(text: content, modifiers: _modifiers)))
        case .anyTextStorage(let content):
            parent.addChild(node: ViewNode(value: TextDrawable(text: content.storage, modifiers: _modifiers)))
        }
    }
}

extension Font {
    var bitmapBaseFontSize: Int { return 8 }
    
    static func sizeFromTextStyle(_ textStyle: Font.TextStyle) -> CGFloat {
        switch textStyle {
        case .body: return 17
        case .largeTitle: return 34
        case .title: return 28
        case .headline: return 17
        case .subheadline: return 15
        case .callout: return 16
        case .footnote: return 13
        case .caption: return 12
        }
    }
    
    var fontSizeToZoomLevel: Int {
        var size: CGFloat
        switch provider {
        case let textStyleProvider as TextStyleProvider:
            size = Font.sizeFromTextStyle(textStyleProvider.style)
        case let systemProvider as SystemProvider:
            size = systemProvider.size
        default:
            size = Font.sizeFromTextStyle(Font.TextStyle.body)
        }
        return max(Int(size) / bitmapBaseFontSize, 1)
    }
}
