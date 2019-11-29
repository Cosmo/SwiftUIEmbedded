import OpenSwiftUI
import Pixels
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
        
        let x = node.ancestors.reduce(0, { $0 + $1.value.origin.x }) + node.value.origin.x + Int(parentPadding.leading)
        let y = node.ancestors.reduce(0, { $0 + $1.value.origin.y }) + node.value.origin.y + Int(parentPadding.top)
        
        let width = node.value.size.width
        let height = node.value.size.height
        
        if debugViews {
            canvas.drawBox(x: x,
                           y: y,
                           width: width,
                           height: node.value.size.height,
                           color: canvas.unsignedIntegerFromColor(Color.gray),
                           dotted: true,
                           brushSize: 1)
        }
        
        if let colorNode = node.value as? ColorDrawable {
            let color = canvas.unsignedIntegerFromColor(colorNode.color)
            canvas.drawBox(x: x,
                           y: y,
                           width: width,
                           height: node.value.size.height,
                           color: color,
                           dotted: false,
                           brushSize: 1,
                           filled: true)
        }
        
        if let backgroundNode = node.value as? ModifiedContentDrawable<_BackgroundModifier<Color>> {
            let color = canvas.unsignedIntegerFromColor(backgroundNode.modifier.background)
            canvas.drawBox(x: x,
                           y: y,
                           width: width,
                           height: node.value.size.height,
                           color: color,
                           dotted: false,
                           brushSize: 1,
                           filled: true)
        }
        
        if let textNode = node.value as? TextDrawable {
            let color = canvas.unsignedIntegerFromColor(textNode.resolvedColor)
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
            canvas.drawBitmap(bytes: imageNode.imageData.bytes,
                              x: x,
                              y: y,
                              width: imageNode.imageData.size.width,
                              height: imageNode.imageData.size.height)
        }
        
        if let _ = node.value as? CircleDrawable {
            let color = canvas.unsignedIntegerFromColor(Color.primary)
            canvas.drawCircle(xm: x + (width / 2), ym: y + (width / 2), radius: width / 2, color: color)
        }
        
        if let _ = node.value as? DividerDrawable {
            let ancestor = node.ancestors.first(where: { $0.value is VStackDrawable || $0.value is RootDrawable || $0.value is HStackDrawable })
            let color = canvas.unsignedIntegerFromColor(Color.gray)
            
            if let ancestor = ancestor, ancestor.value is HStackDrawable {
                canvas.drawVerticalLine(x: x + width / 2, y: y, height: height, color: color)
            } else {
                canvas.drawHorizontalLine(x: x, y: y + height / 2, width: width, color: color)
            }
        }
        
        if let button = node.value as? ButtonDrawable {
            let frame = CGRect(x: x, y: y, width: width, height: height)
            let action = Interaction(frame: frame, action: button.action)
            interactiveAreas.append(action)
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
        print(tree.lineBasedDescription)
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
