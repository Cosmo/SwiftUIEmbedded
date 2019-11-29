import OpenSwiftUI
import CoreGraphics
import Pixels

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
    var font: PixelFont {
        switch fontSize {
        case 0...4:
            return FontSFCompactText8()
        case 5:
            return FontSFCompactText9()
        case 6:
            return FontSFCompactText10()
        case 7:
            return FontSFCompactText11()
        case 8:
            return FontSFCompactText12()
        case 9:
            return FontSFCompactText13()
        case 10:
            return FontSFCompactText14()
        case 11:
            return FontSFCompactText15()
        case 12...20:
            return FontSFCompactText16()
        default:
            return FontSFCompactText32()
        }
    }
    
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
    
    var fontSize: CGFloat {
        switch provider {
        case let textStyleProvider as TextStyleProvider:
            return Font.sizeFromTextStyle(textStyleProvider.style)
        case let systemProvider as SystemProvider:
            return systemProvider.size
        default:
            return Font.sizeFromTextStyle(Font.TextStyle.body)
        }
    }
}
