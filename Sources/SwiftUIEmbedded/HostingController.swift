import OpenSwiftUI
import Pixels

#if canImport(Foundation)
import Foundation
#else
import CoreGraphicsShim
#endif

#if canImport(AppKit)
import AppKit
#endif

public struct Interaction {
    public var frame: CGRect
    public var action: () -> Void
}

public class HostingController<Content: View> {
    public typealias ColorDepth = UInt32
    public typealias ColorDepthProtocol = FixedWidthInteger & UnsignedInteger
    
    public var tree: ViewNode
    public var interactiveAreas = [Interaction]()
    
    private var canvas: Pixels<ColorDepth>
    private var rootView: Content
    private var debugViews: Bool
    
    public init(rootView: Content, width: Int = 320, height: Int = 240, debugViews: Bool = false) {
        self.canvas = Pixels<ColorDepth>(width: width, height: height, canvasColor: ColorDepth.max)
        self.rootView = rootView
        self.tree = ViewNode(value: RootDrawable())
        self.debugViews = debugViews
    }
    
    private func calculateTreeSizes() {
        let width = canvas.canvasWidth
        let height = canvas.canvasHeight
        let displaySize = Size(width: width, height: height)
        tree.calculateSize(givenWidth: width, givenHeight: height)
        tree.value.size = displaySize
    }
    
    private func drawNodesRecursively(node: ViewNode) {
        guard node.value.size.width > 0 else { return }
        
        let parentPadding = (node.parent?.value as? ModifiedContentDrawable<PaddingModifier>)?.modifier.value ?? EdgeInsets()
        
        var foregroundColor: Color?
        for ancestor in node.ancestors {
            if let color = (ancestor.value as? ModifiedContentDrawable<_EnvironmentKeyWritingModifier<Color?>>)?.modifier.value {
                foregroundColor = color
                break
            }
        }
        
        var colorScheme: ColorScheme = .light
        for ancestor in node.ancestors {
            if let scheme = (ancestor.value as? ModifiedContentDrawable<_EnvironmentKeyWritingModifier<ColorScheme>>)?.modifier.value {
                colorScheme = scheme
                break
            }
        }
        
        let width = node.value.size.width
        let height = node.value.size.height
        
        let x = node.ancestors.reduce(0, { $0 + $1.value.origin.x }) + node.value.origin.x + Int(parentPadding.leading)
        let y = node.ancestors.reduce(0, { $0 + $1.value.origin.y }) + node.value.origin.y + Int(parentPadding.top)
        
        if let colorNode = node.value as? ColorDrawable {
            let color = canvas.unsignedIntegerFromColor(colorNode.color)
            canvas.drawBox(x: x,
                           y: y,
                           width: width,
                           height: height,
                           color: color,
                           dotted: false,
                           brushSize: 1,
                           filled: true)
        }
        
        if let backgroundNode = node.value as? ModifiedContentDrawable<_BackgroundModifier<Color>> {
            let color = canvas.unsignedIntegerFromColor(backgroundNode.modifier.background, colorScheme: colorScheme)
            canvas.drawBox(x: x,
                           y: y,
                           width: width,
                           height: height,
                           color: color,
                           dotted: false,
                           brushSize: 1,
                           filled: true)
        }
        
        if let textNode = node.value as? TextDrawable {
            var textColor = Color.primary
            for modifier in textNode.modifiers {
                switch modifier {
                case .color(let color):
                    if let color = color {
                        textColor = color
                    }
                default: continue
                }
            }
            
            let color = canvas.unsignedIntegerFromColor(textColor, colorScheme: colorScheme)
            canvas.drawBitmapText(text: textNode.text,
                                        x: x,
                                        y: y,
                                        width: width,
                                        height: height,
                                        alignment: .left,
                                        color: color,
                                        font: textNode.resolvedFont.font)
        }
        
        if let imageNode = node.value as? ImageDrawable {
            let color = canvas.unsignedIntegerFromColor(foregroundColor ?? Color.primary)
            canvas.drawBitmap(bytes: imageNode.bitmap.bytes,
                              x: x,
                              y: y,
                              width: imageNode.bitmap.size.width,
                              height: imageNode.bitmap.size.height,
                              color: color)
        }
        
        if let _ = node.value as? CircleDrawable {
            let color = canvas.unsignedIntegerFromColor(foregroundColor ?? Color.primary)
            let diameter = min(width, height)
            let radius = diameter / 2
            var offsetX = 0
            if width > diameter {
                offsetX = (width - diameter) / 2
            }
            var offsetY = 0
            if height > diameter {
                offsetY = (height - diameter) / 2
            }
            canvas.drawCircle(xm: x + radius + offsetX, ym: y + radius + offsetY, radius: radius, color: color)
        }
        
        if let _ = node.value as? RectangleDrawable {
            let color = canvas.unsignedIntegerFromColor(foregroundColor ?? Color.primary)
            canvas.drawBox(x: x, y: y, width: width, height: height, color: color, filled: true)
        }
        
        if let _ = node.value as? DividerDrawable {
            let color = canvas.unsignedIntegerFromColor(foregroundColor ?? Color.gray)
            canvas.drawBox(x: x, y: y, width: width, height: height, color: color, filled: true)
        }
        
        if let button = node.value as? ButtonDrawable {
            let frame = CGRect(x: x, y: y, width: width, height: height)
            let action = Interaction(frame: frame, action: button.action)
            interactiveAreas.append(action)
        }
        
        if debugViews {
            canvas.drawBox(x: x,
                           y: y,
                           width: width,
                           height: height,
                           color: canvas.unsignedIntegerFromColor(Color.purple),
                           dotted: true,
                           brushSize: 1)
        }
        
        if node.isBranch {
            for child in node.children {
                drawNodesRecursively(node: child)
            }
        }
    }
    
    public func redrawnCanvas() -> Pixels<ColorDepth> {
        canvas.clear()
        
        self.tree = ViewNode(value: RootDrawable())
        (rootView.body as? ViewBuildable)?.buildDebugTree(tree: &tree, parent: tree)
        
        calculateTreeSizes()
        print(tree.lineBasedDescription.replacingOccurrences(of: "OpenSwiftUI.", with: ""))
        drawNodesRecursively(node: tree)
        return canvas
    }
    
    #if canImport(AppKit)
    public func createPixelBufferImage() -> NSImage? {
        return redrawnCanvas().image()
    }
    #endif
    
    public func createPixelBuffer() -> [ColorDepth] {
        return redrawnCanvas().bytes
    }
}
