//
//  StaticTreeData.swift
//  MyTreeTutorApp (iOS)
//
//  Created by Benjamin-Smith Bortey on 26/03/2021.
//

import Foundation


let binaryTree = Tree<Int>(50, children: [
    Tree(17, children: [
        Tree(12),
        Tree(23)
    ]),
    Tree(72, children: [
        Tree(54),
        Tree(75)
    ])
])
let uniqueTree = binaryTree.map(Unique.init)
