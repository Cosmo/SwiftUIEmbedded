import OpenSwiftUI
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
        return lhs.uuid == rhs.uuid && lhs.parent == rhs.parent
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
        let numberOfSpacings = degree - 1
        return numberOfSpacings * Self.defaultSpacing
    }
    
    public func calculateSize(givenWidth: Int, givenHeight: Int) {
        guard isBranch else { return }

        switch value {
        case is HStackDrawable:
            calculateNodeWithHorizontallyStackedNodes(givenWidth: givenWidth, givenHeight: givenHeight)
        case is ZStackDrawable:
            calculateNodeWithZStackedNodes(givenWidth: givenWidth, givenHeight: givenHeight)
        default:
            calculateNodeWithVerticallyStackedNodes(givenWidth: givenWidth, givenHeight: givenHeight)
        }
    }
    
    func calculateNodeWithZStackedNodes(givenWidth: Int, givenHeight: Int) {
        let proposedWidth = givenWidth
        let proposedHeight = givenHeight
        
        var maxWidth = 0
        var maxHeight = 0
        
        for child in children {
            child.calculateSize(givenWidth: proposedWidth, givenHeight: givenHeight)
            let wantedWidth = child.value.wantedWidthForProposal(proposedWidth)
            if proposedWidth > wantedWidth {
                if child.value.size.width < 1 {
                    child.value.size.width = wantedWidth
                    maxWidth = max(maxWidth, wantedWidth)
                }
            } else {
                child.value.size.width = proposedWidth
                maxWidth = max(maxWidth, proposedWidth)
            }
        }
        
        for child in children {
            child.calculateSize(givenWidth: proposedWidth, givenHeight: proposedHeight)
            let wantedHeight = child.value.wantedHeightForProposal(proposedHeight)
            if proposedHeight > wantedHeight {
                if child.value.size.height < 1 {
                    child.value.size.height = wantedHeight
                    maxHeight = max(maxHeight, wantedHeight)
                }
            } else {
                child.value.size.height = proposedHeight
                maxHeight = max(maxHeight, proposedHeight)
            }
        }
        
        value.size = Size(width: maxWidth, height: maxHeight)
    }
    
    func calculateNodeWithVerticallyStackedNodes(givenWidth: Int, givenHeight: Int) {
        var remainingHeight = givenHeight - internalSpacingRequirements // - Int(paddingFromParent.leading) - Int(paddingFromParent.trailing)
        var remainingChildren = degree
        
        var requestedHeightsWithIndex = [(index: Int, height: Int)]()
        var dividerIndicies = [Int]()
        for (index, child) in children.enumerated() {
            let proposedHeight = remainingHeight / remainingChildren
            
            child.calculateSize(givenWidth: givenWidth, givenHeight: proposedHeight)
            let wantedHeight = child.value.wantedHeightForProposal(proposedHeight)
            
            if child.value is DividerDrawable {
                child.value.size.height = 1
            }
            
            if proposedHeight > wantedHeight {
                if child.value is DividerDrawable {
                    dividerIndicies.append(index)
                }
                remainingHeight = remainingHeight - wantedHeight
                if child.value.size.height < 1 {
                    child.value.size.height = wantedHeight
                }
                remainingChildren -= 1
            } else if child.value.size.height > 0 {
                remainingHeight = remainingHeight - child.value.size.height
                remainingChildren -= 1
            } else {
                requestedHeightsWithIndex.append((index: index, height: wantedHeight))
            }
        }
        
        
        if requestedHeightsWithIndex.count > 0 {
            let proposedHeight = remainingHeight / requestedHeightsWithIndex.count
            for unclearHeight in requestedHeightsWithIndex {
                if children[unclearHeight.index].value.size.height == 0 {
                    children[unclearHeight.index].value.size.height = proposedHeight
                }
            }
        }
        
        var maxWidth = 0
        for child in children {
            let childWidth = child.value.wantedWidthForProposal(givenWidth)
            if child.value.size.width < 1 {
                child.value.size.width = childWidth
            }
            if childWidth > maxWidth {
                maxWidth = childWidth
            }
        }
        
        let total = children.reduce(0, { $0 + $1.value.size.height }) + internalSpacingRequirements
        let totalWidth = children.map { $0.value.size.width }.max() ?? 1
        
        if dividerIndicies.count > 0 {
            for dividerIndex in dividerIndicies {
                children[dividerIndex].value.size.width = totalWidth
            }
        }
        
        value.size = Size(width: totalWidth, height: total)
        
        for (index, child) in children.enumerated() {
            if index > 0 {
                let previousNode = children[index - 1]
                child.value.origin.y = previousNode.value.origin.y + previousNode.value.size.height + ViewNode.defaultSpacing
            }
        }
    }
    
    func calculateNodeWithHorizontallyStackedNodes(givenWidth: Int, givenHeight: Int) {
        var remainingWidth = givenWidth - internalSpacingRequirements // - Int(paddingFromParent.leading) - Int(paddingFromParent.trailing)
        
        var remainingChildren = degree
        
        var requestedWidthsWithIndex = [(index: Int, width: Int)]()
        var dividerIndicies = [Int]()
        for (index, child) in children.enumerated() {
            let proposedWidth = remainingWidth / remainingChildren
            
            child.calculateSize(givenWidth: proposedWidth, givenHeight: givenHeight)
            let wantedWidth = child.value.wantedWidthForProposal(proposedWidth)
            
            if child.value is DividerDrawable {
                child.value.size.width = 1
            }
            
            if proposedWidth > wantedWidth {
                if child.value is DividerDrawable {
                    dividerIndicies.append(index)
                }
                remainingWidth = remainingWidth - wantedWidth
                if child.value.size.width < 1 {
                    child.value.size.width = wantedWidth
                }
                remainingChildren -= 1
            } else if child.value.size.width > 0 {
                remainingWidth = remainingWidth - child.value.size.width
                remainingChildren -= 1
            } else {
                requestedWidthsWithIndex.append((index: index, width: wantedWidth))
            }
        }
        
        
        if requestedWidthsWithIndex.count > 0 {
            let proposedWidth = remainingWidth / requestedWidthsWithIndex.count
            for unclearWidth in requestedWidthsWithIndex {
                if children[unclearWidth.index].value.size.width == 0 {
                    children[unclearWidth.index].value.size.width = proposedWidth
                }
            }
        }
        
        var maxHeight = 0
        for child in children {
            let childHeight = child.value.wantedHeightForProposal(givenHeight)
            if child.value.size.height < 1 {
                child.value.size.height = childHeight
            }
            if childHeight > maxHeight {
                maxHeight = childHeight
            }
        }
        
        let total = children.reduce(0, { $0 + $1.value.size.width }) + internalSpacingRequirements
        let totalHeight = children.map { $0.value.size.height }.max() ?? 1
        
        if dividerIndicies.count > 0 {
            for dividerIndex in dividerIndicies {
                children[dividerIndex].value.size.height = totalHeight
            }
        }
        
        value.size = Size(width: total, height: totalHeight)
        
        for (index, child) in children.enumerated() {
            if index > 0 {
                let previousNode = children[index - 1]
                child.value.origin.x = previousNode.value.origin.x + previousNode.value.size.width + ViewNode.defaultSpacing
            }
        }
    }
}
