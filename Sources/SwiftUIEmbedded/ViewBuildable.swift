//
//  ViewBuildable.swift
//  
//
//  Created by Devran on 30.10.19.
//

public protocol ViewBuildable {
    func buildDebugTree(tree: inout Node, parent: Node)
}
