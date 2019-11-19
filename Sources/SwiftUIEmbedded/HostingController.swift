import OpenSwiftUI
import Pixels
#if canImport(AppKit)
import AppKit
#endif

public class HostingController<Content: View> {
    public typealias ColorDepth = UInt32
    public typealias ColorDepthProtocol = FixedWidthInteger & UnsignedInteger
    private var canvas: Pixels<ColorDepth>
    
    private var rootView: Content
    private var tree: ViewNode
    
    public init(rootView: Content, width: Int = 320, height: Int = 240) {
        self.canvas = Pixels<ColorDepth>(width: width, height: height, canvasColor: ColorDepth.max)
        self.rootView = rootView
        self.tree = ViewNode(value: RootDrawable())
        (rootView.body as? ViewBuildable)?.buildDebugTree(tree: &tree, parent: tree)
    }
    
    private func calculateTreeSizes() {
        let width = canvas.canvasWidth
        let height = canvas.canvasHeight
        let displaySize = Size(width: width, height: height)
        tree.calculateSize(givenWidth: width)
        tree.value.size = displaySize
    }
    
    private func drawNodesRecursively(node: ViewNode) {
        guard node.value.size.width > 0 else { return }
        
        let parentPadding = (node.parent?.value as? ModifiedContentDrawable<PaddingModifier>)?.modifier.value ?? EdgeInsets()
        
        let x = node.ancestors.reduce(0, { $0 + $1.value.origin.x }) + node.value.origin.x + Int(parentPadding.leading)
        let y = node.ancestors.reduce(0, { $0 + $1.value.origin.y }) + node.value.origin.y + Int(parentPadding.top)
        
        let width = node.value.size.width
        let height = node.value.size.height
        
        canvas.drawBox(x: x,
                       y: y,
                       width: width,
                       height: node.value.size.height,
                       color: canvas.unsignedIntegerFromColor(Color.gray),
                       dotted: true,
                       brushSize: 1)
        
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
                                        size: textNode.resolvedFont.fontSizeToZoomLevel)
        }
        
        if let imageNode = node.value as? ImageDrawable {
            canvas.drawBitmap(bytes: imageNode.imageData.bytes,
                              x: x,
                              y: y,
                              width: imageNode.imageData.size.width,
                              height: imageNode.imageData.size.height)
        }
        
        if let _ = node.value as? CircleDrawable {
            canvas.drawCircle(xm: x + (width / 2), ym: y + (width / 2), radius: width / 2)
        }
        
        if let _ = node.value as? DividerDrawable {
            let ancestor = node.ancestors.first(where: { $0.value is VStackDrawable || $0.value is RootDrawable || $0.value is HStackDrawable })
            
            if let ancestor = ancestor, ancestor.value is HStackDrawable {
                canvas.drawVerticalLine(x: x + width / 2, y: y, height: height)
            } else {
                canvas.drawHorizontalLine(x: x, y: y + height / 2, width: width)
            }
        }
        
        
        if node.isBranch {
            for child in node.children {
                drawNodesRecursively(node: child)
            }
        }
    }
    
    #if canImport(AppKit)
    public func createPixelBufferImage() -> NSImage? {
        calculateTreeSizes()
        print(tree.lineBasedDescription)
        drawNodesRecursively(node: tree)
        return canvas.image()
    }
    #endif
    
    public func createPixelBuffer() -> [ColorDepth] {
        calculateTreeSizes()
        print(tree.lineBasedDescription)
        drawNodesRecursively(node: tree)
        return canvas.bytes
    }
}
