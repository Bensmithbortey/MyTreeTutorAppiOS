//
//  BinaryTreeViewModel.swift
//  MyTreeTutorApp (iOS)
//
//  Created by Benjamin-Smith Bortey on 18/03/2021.
//

//import Combine
//
//protocol TreeViewModel {
//    func insert(value: Int)
//    // TODO: delete, select, ...
//    func deleteTree()
//    func deleteSelected()
//    func selectNode(value: Int)
//}
//
//
//class BinaryTreeViewModel: ObservableObject, TreeViewModel {
//
//    var tree: BinaryTree?
//    let objectWillChange = PassthroughSubject<Void, Never>()
//
//    func insert(value: Int) {
//        if let tree = tree {
//            tree.insertNode(value: value)
//        } else {
//            tree = BinaryTree(value: value)
//        }
//        objectWillChange.send()
//    }
//
//    func deleteTree() {
//        tree?.delete()
//        objectWillChange.send()
//    }
//
//    func deleteSelected() {
//        if let selectedNode = tree?.findSelectedNode() {
//            selectedNode.delete()
//        }
//        objectWillChange.send()
//    }
//
//    func selectNode(value: Int) {
//        // Deselect the currently selected node
//        if let selectedNode = tree?.findSelectedNode() {
//            selectedNode.selected = false
//        }
//        // Select the new node
//        if let selectedNode = tree?.findNode(value: value) {
//            selectedNode.selected = true
//        }
//        objectWillChange.send()
//    }
//
//}
