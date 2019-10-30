import OpenSwiftUI
import CoreGraphics
import Foundation

public class Node {
    public weak var parent: Node?
    public var children = [Node]()
    public var value: Drawable
    public var uuid = UUID()
    
    public init(value: Drawable) {
        self.value = value
    }
    
    public func addChild(node: Node) {
        children.append(node)
        node.parent = self
    }
    
    public var ancestors: [Node] {
        var nodes: [Node] = []
        var node: Node? = self
        
        repeat {
            if let node = node, node.uuid != self.uuid {
                nodes.append(node)
            }
            node = node?.parent
            if node?.parent == nil {
                break
            }
        } while node?.parent != nil
        
        return nodes
    }
}

extension Node {
    public var lineBasedOutput: String {
        var outputBuffer = ""
        generateLines(outputBuffer: &outputBuffer)
        return outputBuffer
    }
    
    private func generateLines(outputBuffer: inout String, prefix: String = "", childrenPrefix: String = "") {
        outputBuffer.append("\(prefix)\(value.debugDescription)\n")
        let childrenCount = children.count
        for (index, child) in children.enumerated() {
            if childrenCount > index.advanced(by: 1) {
                child.generateLines(outputBuffer: &outputBuffer, prefix: childrenPrefix + "├── ", childrenPrefix: childrenPrefix + "│   ")
            } else {
                child.generateLines(outputBuffer: &outputBuffer, prefix: childrenPrefix + "└── ", childrenPrefix: childrenPrefix + "    ")
            }
        }
    }
}

extension Node {
    static var defaultSpacing: Int {
        return 8
    }
    
    var internalSpacingRequirements: Int {
        let numberOfSpacings = max(children.count - 1, 0)
        return numberOfSpacings * Self.defaultSpacing
    }
    
    public func calculateSize(givenWidth: Int) {
        guard children.count > 0 else { return }
        
        print(Mirror(reflecting: self.value).subjectType)
        
        if self.value is VStackDrawable || self.value is RootDrawable {
            var remainingWidth = givenWidth - internalSpacingRequirements
            var proposedWidth = remainingWidth
            var totalWidth = internalSpacingRequirements
            
            var requestedWidthsWithIndex = [(index: Int, width: Int)]()
            for (index, child) in children.enumerated() {
                child.calculateSize(givenWidth: proposedWidth)
                let wantedWidth = child.value.wantedWidthForProposal(proposedWidth)
                if proposedWidth > wantedWidth {
                    remainingWidth = remainingWidth - wantedWidth
                    if child.value.size.width < 1 {
                        child.value.size.width = wantedWidth
                    }
                    totalWidth = totalWidth + wantedWidth
                } else {
                    requestedWidthsWithIndex.append((index: index, width: wantedWidth))
                }
            }
            
            if requestedWidthsWithIndex.count > 0 {
                proposedWidth = remainingWidth
                for unclearWidth in requestedWidthsWithIndex {
                    if children[unclearWidth.index].value.size.width < 1 {
                        children[unclearWidth.index].value.size.width = proposedWidth
                    }
                    totalWidth = totalWidth + proposedWidth
                }
            }
            
            var maxHeight = 0
            for child in children {
                let childHeight = child.value.wantedHeightForProposal(remainingWidth)
                if child.value.size.height < 1 {
                    child.value.size.height = childHeight
                }
                maxHeight += childHeight
            }
            
            let total = children.map { $0.value.size.width }.max()
            let totalHeight = children.reduce(0, { $0 + $1.value.size.height })
            
            value.size = Size(width: total ?? 0, height: totalHeight)
            
            for (index, child) in children.enumerated() {
                if index > 0 {
                    let previousNode = children[index - 1]
                    child.value.origin.y = previousNode.value.origin.y + previousNode.value.size.height// + Node.defaultSpacing
                }
            }
        }
        
        if self.value is HStackDrawable {
            var remainingWidth = givenWidth - internalSpacingRequirements
            var proposedWidth = remainingWidth / children.count
            var totalWidth = internalSpacingRequirements
            
            var requestedWidthsWithIndex = [(index: Int, width: Int)]()
            for (index, child) in children.enumerated() {
                child.calculateSize(givenWidth: proposedWidth)
                let wantedWidth = child.value.wantedWidthForProposal(proposedWidth)
                if proposedWidth > wantedWidth {
                    remainingWidth = remainingWidth - wantedWidth
                    if child.value.size.width < 1 {
                        child.value.size.width = wantedWidth
                    }
                    totalWidth = totalWidth + wantedWidth
                } else {
                    requestedWidthsWithIndex.append((index: index, width: wantedWidth))
                }
            }
            
            if requestedWidthsWithIndex.count > 0 {
                proposedWidth = remainingWidth / requestedWidthsWithIndex.count
                for unclearWidth in requestedWidthsWithIndex {
                    if children[unclearWidth.index].value.size.width < 1 {
                        children[unclearWidth.index].value.size.width = proposedWidth
                    }
                    totalWidth = totalWidth + proposedWidth
                }
            }
            
            var maxHeight = 0
            for child in children {
                let childHeight = child.value.wantedHeightForProposal(remainingWidth)
                if child.value.size.height < 1 {
                    child.value.size.height = childHeight
                }
                if childHeight > maxHeight {
                    maxHeight = childHeight
                }
            }
            
            let total = children.reduce(0, { $0 + $1.value.size.width }) + internalSpacingRequirements
            let totalHeight = children.map { $0.value.size.height }.max()
            value.size = Size(width: total, height: totalHeight ?? 0)
            
            for (index, child) in children.enumerated() {
                if index > 0 {
                    let previousNode = children[index - 1]
                    child.value.origin.x = previousNode.value.origin.x + previousNode.value.size.width + Node.defaultSpacing
                }
            }
        }
    }
}
