import OpenSwiftUI
import Nodes
import Foundation

public final class ViewNode: Node {
    public typealias Value = Drawable
    public var value: Value
    public weak var parent: ViewNode?
    public var children: [ViewNode]
    public var uuid = UUID()
    public var processor: String
    
    public init(value: Value) {
        self.value = value
        self.children = []
        self.processor = ""
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
        case is VStackDrawable:
            calculateNodeWithVerticallyStackedNodes(givenWidth: givenWidth, givenHeight: givenHeight)
        default:
            calculateNodeWithZStackedNodes(givenWidth: givenWidth, givenHeight: givenHeight)
        }
    }
    
    func calculateNodeWithZStackedNodes(givenWidth: Int, givenHeight: Int) {
        for (_, child) in children.enumerated() {
            child.processor = "* ZStack"
            child.calculateSize(givenWidth: givenWidth, givenHeight: givenHeight)
            if !child.value.passthrough {
                let wantedWidth = child.value.wantedWidthForProposal(givenWidth, otherLength: givenHeight)
                let wantedHeight = child.value.wantedHeightForProposal(givenHeight, otherLength: givenWidth)
                child.value.size.width = wantedWidth
                child.value.size.height = wantedHeight
            }
        }
        
        value.size.width = children.reduce(0, { $0 + $1.value.size.width }) + internalSpacingRequirements
        value.size.height = children.reduce(0, { $0 + $1.value.size.height }) + internalSpacingRequirements
        
        processor = "ZStack"
    }
    
    func calculateNodeWithHorizontallyStackedNodes(givenWidth: Int, givenHeight: Int) {
        // Substract all spacings from the width
        var remainingWidth = givenWidth - internalSpacingRequirements
        
        // Keep record of elements that we already processed
        var processedNodeIndices = [Int]()
        
        // Keep record of the number of unprocessed children
        var remainingChildren = degree
        
        // Least flexible items first (elements with an intrinsic width [and maybe height])
        for (index, child) in children.enumerated() {
            if !processedNodeIndices.contains(index) {
                // Images have their own intrinsic size
                if child.value is ImageDrawable {
                    let width = child.value.wantedWidthForProposal(Int.max, otherLength: nil)
                    child.value.size.height = child.value.wantedHeightForProposal(Int.max, otherLength: nil)
                    child.value.size.width = width
                    remainingWidth -= width
                    processedNodeIndices.append(index)
                    remainingChildren -= 1
                    child.processor = "* HStack"
                }
                
                // Dividers claim the whole height that is given and set their own width
                if child.value is DividerDrawable {
                    let width = child.value.wantedWidthForProposal(givenWidth, otherLength: nil)
                    child.value.size.height = child.value.wantedHeightForProposal(givenHeight, otherLength: nil)
                    child.value.size.width = width
                    remainingWidth -= width
                    processedNodeIndices.append(index)
                    remainingChildren -= 1
                    child.processor = "* HStack"
                }
            }
        }
        
        // Process items that would fit inside the proposal
        // loop and repeat until only elements that wont fit remain
        var thereAreStillSmallOnes = true
        while thereAreStillSmallOnes {
            var smallOneFound = false
            for (index, child) in children.enumerated() {
                if !processedNodeIndices.contains(index) {
                    let proposedWidth = remainingWidth / remainingChildren
                    let wantedWidth = child.value.wantedWidthForProposal(proposedWidth, otherLength: givenHeight)
                    // When an element fits, it should take what it needs
                    if proposedWidth > wantedWidth {
                        smallOneFound = true
                        let wantedHeight = child.value.wantedHeightForProposal(givenHeight, otherLength: wantedWidth)
                        child.value.size.height = wantedHeight
                        child.value.size.width = wantedWidth
                        remainingWidth -= wantedWidth
                        processedNodeIndices.append(index)
                        remainingChildren -= 1
                        child.processor = "* HStack"
                        child.calculateSize(givenWidth: wantedWidth, givenHeight: wantedHeight)
                    }
                }
            }
            if smallOneFound == false {
                thereAreStillSmallOnes = false
            }
        }
        
        // Process items that wont fit
        if remainingChildren > 0 {
            let proposedWidth = remainingWidth / remainingChildren
            for (index, child) in children.enumerated() {
                if !processedNodeIndices.contains(index) {
                    let wantedHeight = child.value.wantedHeightForProposal(givenHeight, otherLength: proposedWidth)
                    child.value.size.height = wantedHeight
                    child.value.size.width = proposedWidth
                    remainingWidth -= proposedWidth
                    processedNodeIndices.append(index)
                    remainingChildren -= 1
                    child.processor = "* HStack"
                    child.calculateSize(givenWidth: proposedWidth, givenHeight: wantedHeight)
                }
            }
        }
        
        // Position element after element
        for (index, child) in children.enumerated() {
            if index > 0 {
                let previousNode = children[index - 1]
                child.value.origin.x = previousNode.value.origin.x + previousNode.value.size.width + ViewNode.defaultSpacing
            }
        }
        
        value.size.width = children.reduce(0, { $0 + $1.value.size.width }) + internalSpacingRequirements
        value.size.height = children.max(by: { (lhs, rhs) -> Bool in lhs.value.size.height < rhs.value.size.height })!.value.size.height
        processor = "HStack"
    }
    
    func calculateNodeWithVerticallyStackedNodes(givenWidth: Int, givenHeight: Int) {
        // Substract all spacings from the height
        var remainingHeight = givenHeight - internalSpacingRequirements
        
        // Keep record of elements that we already processed
        var processedNodeIndices = [Int]()
        
        // Keep record of the number of unprocessed children
        var remainingChildren = degree
        
        // Least flexible items first (elements with an intrinsic height [and maybe width])
        for (index, child) in children.enumerated() {
            if !processedNodeIndices.contains(index) {
                // Images have their own intrinsic size
                if child.value is ImageDrawable {
                    let height = child.value.wantedHeightForProposal(Int.max, otherLength: nil)
                    child.value.size.width = child.value.wantedWidthForProposal(Int.max, otherLength: nil)
                    child.value.size.height = height
                    remainingHeight -= height
                    processedNodeIndices.append(index)
                    remainingChildren -= 1
                    child.processor = "* VStack"
                }
                
                // Dividers claim the whole width that is given and set their own height
                if child.value is DividerDrawable {
                    let height = child.value.wantedHeightForProposal(givenHeight, otherLength: nil)
                    child.value.size.width = child.value.wantedWidthForProposal(givenWidth, otherLength: nil)
                    child.value.size.height = height
                    remainingHeight -= height
                    processedNodeIndices.append(index)
                    remainingChildren -= 1
                    child.processor = "* VStack"
                }
            }
        }
        
        // Process items that would fit inside the proposal
        // loop and repeat until only elements that wont fit remain
        var thereAreStillSmallOnes = true
        while thereAreStillSmallOnes {
            var smallOneFound = false
            for (index, child) in children.enumerated() {
                if !processedNodeIndices.contains(index) {
                    let proposedHeight = remainingHeight / remainingChildren
                    let wantedHeight = child.value.wantedHeightForProposal(proposedHeight, otherLength: givenWidth)
                    // When an element fits, it should take what it needs
                    if proposedHeight > wantedHeight {
                        smallOneFound = true
                        let wantedWidth = child.value.wantedWidthForProposal(givenWidth, otherLength: wantedHeight)
                        child.value.size.width = wantedWidth
                        child.value.size.height = wantedHeight
                        remainingHeight -= wantedHeight
                        processedNodeIndices.append(index)
                        remainingChildren -= 1
                        child.processor = "* VStack"
                        child.calculateSize(givenWidth: wantedWidth, givenHeight: wantedHeight)

                    }
                }
            }
            if smallOneFound == false {
                thereAreStillSmallOnes = false
            }
        }
        
        // Process items that wont fit
        if remainingChildren > 0 {
            var proposedHeight = remainingHeight / remainingChildren
            for (index, child) in children.enumerated() {
                if !processedNodeIndices.contains(index), child.value.passthrough {
                    let wantedWidth = child.value.wantedWidthForProposal(givenWidth, otherLength: proposedHeight)
                    child.value.size.width = wantedWidth
                    remainingHeight -= child.value.size.height
                    processedNodeIndices.append(index)
                    remainingChildren -= 1
                    child.processor = "* VStack"
                    child.calculateSize(givenWidth: wantedWidth, givenHeight: proposedHeight)
                }
            }
            
            proposedHeight = remainingHeight / remainingChildren
            for (index, child) in children.enumerated() {
                if !processedNodeIndices.contains(index) {
                    let wantedWidth = child.value.wantedWidthForProposal(givenWidth, otherLength: proposedHeight)
                    child.value.size.width = wantedWidth
                    child.value.size.height = proposedHeight
                    remainingHeight -= proposedHeight
                    processedNodeIndices.append(index)
                    remainingChildren -= 1
                    child.processor = "* VStack"
                    child.calculateSize(givenWidth: wantedWidth, givenHeight: proposedHeight)
                }
            }
        }
        
        // Position element after element
        for (index, child) in children.enumerated() {
            if index > 0 {
                let previousNode = children[index - 1]
                child.value.origin.y = previousNode.value.origin.y + previousNode.value.size.height + ViewNode.defaultSpacing
            }
        }
        
        // value.size.width = children.max(by: { (lhs, rhs) -> Bool in lhs.value.size.width > rhs.value.size.width })!.value.size.width + ViewNode.defaultSpacing
        value.size.height = children.reduce(0, { $0 + $1.value.size.height }) + internalSpacingRequirements
        processor = "VStack"
    }
}
