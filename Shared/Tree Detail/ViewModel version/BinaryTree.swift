//
//  BinaryTree.swift
//  MyTreeTutorApp (iOS)
//
//  Created by Benjamin-Smith Bortey on 18/03/2021.
//

//import Foundation
//
//protocol Tree {
//    var value: Int { set get }
//
//    func insertNode(value: Int)
//    func findNode(value: Int) -> Self?
//    func findSelectedNode() -> Self?
//    func delete()
//}
//
//class BinaryTree: Tree, Equatable, CustomStringConvertible {
//    var value: Int
//
//    var selected: Bool = false
//
//    var left: BinaryTree?
//    var right: BinaryTree?
//    weak var parent: BinaryTree?
//
//    init(value: Int) {
//        self.value = value
//    }
//
//    func insertNode(value: Int) {
//        if self.value > value {
//            if let tree = left {
//                tree.insertNode(value: value)
//            } else {
//                left = BinaryTree(value: value)
//                left?.parent = self
//            }
//        } else {
//
//            if let tree = right {
//                tree.insertNode(value: value)
//            } else {
//                right = BinaryTree(value: value)
//                right?.parent = self
//            }
//        }
//    }
//
//    func findNode(value: Int) -> Self? {
//        if self.value == value {
//            return self
//        }
//
//        if let tree = left, value < self.value {
//            return tree.findNode(value: value) as? Self
//        }
//        if let tree = right, value > self.value {
//            return tree.findNode(value: value) as? Self
//        }
//
//        return nil
//    }
//
//    func findSelectedNode() -> Self? {
//        if selected {
//            return self
//        }
//
//        if let tree = left {
//            return tree.findSelectedNode() as? Self
//        }
//        if let tree = right {
//            return tree.findSelectedNode() as? Self
//        }
//
//        return nil
//    }
//
//    func delete() {
//        if parent?.left == self {
//            parent?.left = nil
//        } else
//        if parent?.right == self {
//            parent?.right = nil
//        }
//    }
//
//    // MARK: - Equatable
//
//    static func == (lhs: BinaryTree, rhs: BinaryTree) -> Bool {
//        return lhs.value == rhs.value
//    }
//
//    var description: String {
//        return "\(value)\n\(left?.description ?? "")  \(right?.description ?? "")"
//    }
//}
