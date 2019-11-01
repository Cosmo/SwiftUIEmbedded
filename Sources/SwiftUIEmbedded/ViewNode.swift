import OpenSwiftUI
import CoreGraphics
import Foundation
import Nodes

public final class ViewNode: Node {
    public typealias Value = Drawable
    public var value: Value
    public weak var parent: ViewNode?
    public var children: [ViewNode]
    public var uuid = UUID()
    public init(value: Value) {
        self.value = value
        self.children = []
    }
}

extension ViewNode: Equatable {
    public static func == (lhs: ViewNode, rhs: ViewNode) -> Bool {
        return lhs.value.debugDescription == rhs.value.debugDescription && lhs.parent == rhs.parent
    }
}

extension ViewNode: CustomStringConvertible {
    public var description: String {
        return "\(value)"
    }
}

extension ViewNode {
    static var defaultSpacing: Int {
        return 8
    }
    
    var internalSpacingRequirements: Int {
        let numberOfSpacings = max(degree - 1, 0)
        return numberOfSpacings * Self.defaultSpacing
    }
    
    public func calculateSize(givenWidth: Int) {
        guard isBranch else { return }
        
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
            var proposedWidth = remainingWidth / degree
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
                    child.value.origin.x = previousNode.value.origin.x + previousNode.value.size.width + ViewNode.defaultSpacing
                }
            }
        }
    }
}
