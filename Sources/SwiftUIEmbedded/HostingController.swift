import OpenSwiftUI
import Pixels
#if canImport(AppKit)
import AppKit
#endif

public class HostingController<Content: View> {
    public typealias ColorDepth = UInt32
    public typealias ColorDepthProtocol = FixedWidthInteger & UnsignedInteger
    var pixelBuffer = Pixels<ColorDepth>(width: 640, height: 640)
    
    public var rootView: Content
    public var tree: ViewNode
    public init(rootView: Content) {
        self.rootView = rootView
        
        self.tree = ViewNode(value: RootDrawable())
        (rootView.body as? ViewBuildable)?.buildDebugTree(tree: &tree, parent: tree)
    }
    
    public func calculateTreeSizes() {
        let displaySize = Size(width: pixelBuffer.canvasWidth, height: pixelBuffer.canvasHeight)
        tree.calculateSize(givenWidth: displaySize.width)
        tree.value.size = displaySize
    }
    
    public func createTree() {
        calculateTreeSizes()
        print(tree.lineBasedDescription)
    }
    
    func drawElement(node: ViewNode) {
        if node.value.size.width == Size.zero.width {
            return
        }
        
        let x = node.ancestors.reduce(0, { $0 + $1.value.origin.x }) + node.value.origin.x
        let y = node.ancestors.reduce(0, { $0 + $1.value.origin.y }) + node.value.origin.y
        
        let width = node.value.size.width
        let height = node.value.size.height
        
        pixelBuffer.drawBox(x: x,
                            y: y,
                            width: width,
                            height: node.value.size.height,
                            color: (0x00000000..<0xFFFFFF00).randomElement()!, brushSize: 3)
        
        if let textNode = node.value as? TextDrawable {
            pixelBuffer.drawBitmapText(text: textNode.text,
                                       x: x,
                                       y: y,
                                       width: width,
                                       height: height,
                                       alignment: .left,
                                       size: 2)
        }
        
        if let _ = node.value as? CircleDrawable {
            pixelBuffer.drawCircle(xm: x + (width / 2), ym: y + (width / 2), radius: width / 2)
        }
        
        if node.children.count > 0 {
            for child in node.children {
                drawElement(node: child)
            }
        }
    }
    
    #if canImport(AppKit)
    public func createPixelBuffer() -> NSImage? {
        calculateTreeSizes()
        print(tree.lineBasedDescription)
        
        drawElement(node: tree)
        
        return pixelBuffer.image()
    }
    #endif
}
