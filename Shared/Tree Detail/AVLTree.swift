//
//  AVLTree.swift
//  MyTreeTutorApp (iOS)
//
//  Created by Miroslav Kutak on 21.04.2021.
//

import Foundation

/// AVL Tree datastructure that holds nodes with `A` as the value.
class AVLTree<A>: Tree<A> {

}

extension AVLTree where A == Unique<Int> {


    var balanceFactor: Int {
        let leftHeight = left()?.height ?? -1
        let rightHeight = right()?.height ?? -1

        return leftHeight - rightHeight
    }

    @discardableResult
    private func balance()
    -> AVLTree<A> {

        switch balanceFactor {
        case 2:
            if let leftChild = left() as? AVLTree<A>,
               leftChild.balanceFactor == -1 {
                return leftRightRotate()
            } else {
                return rightRotate()
            }
        case -2:
            if let rightChild = right() as? AVLTree<A>,
               rightChild.balanceFactor == 1 {
                return rightLeftRotate()
            } else {
                return leftRotate()
            }
        default: // -1, 0, 1
            return self
        }
    }


    @discardableResult
    private func leftRotate() -> AVLTree<A> {
        // 1
        guard let pivot = right() as? AVLTree<A> else {
            return self
        }
        // 2
        if let pivotLeft = pivot.left() {
            children[1] = pivotLeft
        }
        // 3
        pivot.children[0] = self
        // 4
        height = max(leftHeight, rightHeight) + 1
        pivot.height = max(pivot.leftHeight, pivot.rightHeight) + 1
        // 5
        replaceSelfInParent(with: pivot)
        return pivot
    }

    @discardableResult
    private func rightRotate() -> AVLTree<A> {
        // 1
        guard let pivot = left() as? AVLTree<A> else {
            return self
        }
        // 2
        if let pivotRight = pivot.right() {
            setLeft(pivotRight)
        }
        // 3
        setRight(self)
        // 4
        height = max(leftHeight, rightHeight) + 1
        pivot.height = max(pivot.leftHeight, pivot.rightHeight) + 1
        // 5
        replaceSelfInParent(with: pivot)
        return pivot
    }

    @discardableResult
    func rightLeftRotate() -> AVLTree<A> {
        guard let rightChild = right() as? AVLTree<A> else {
            return self
        }

        let pivotRight = rightChild.rightRotate()
        setRight(pivotRight)
        return leftRotate()
    }

    @discardableResult
    func leftRightRotate() -> AVLTree<A> {
        guard let leftChild = left() as? AVLTree<A> else {
            return self
        }

        let pivotLeft = leftChild.leftRotate()
        setLeft(pivotLeft)
        return rightRotate()
    }

    func replaceSelfInParent(with node: AVLTree<A>) {
        let id = value.id
        parent?.children.removeAll(where: { $0.value.id == id })
        parent?.insert(node)
    }

    func insert(_ number: Int) {
        insert(AVLTree(Unique(number)))
    }

    @discardableResult
    func insert(_ node: AVLTree<A>) -> AVLTree<A> {
        super.insert(node)

        let balancedNode = balance()
        balancedNode.height = max(balancedNode.leftHeight, balancedNode.rightHeight) + 1
        return balancedNode
    }


//    Since with a single insertion the height of an AVL subtree cannot increase by more than one, the temporary balance factor of a node after an insertion will be in the range [–2,+2]. For each node checked, if the temporary balance factor remains in the range from –1 to +1 then only an update of the balance factor and no rotation is necessary. However, if the temporary balance factor becomes less than –1 or greater than +1, the subtree rooted at this node is AVL unbalanced, and a rotation is needed.[9]:52 With insertion as the code below shows, the adequate rotation immediately perfectly rebalances the tree.

//    The retracing can stop if the balance factor becomes 0 implying that the height of that subtree remains unchanged.
//
//    If the balance factor becomes ±1 then the height of the subtree increases by one and the retracing needs to continue.
//
//    If the balance factor temporarily becomes ±2, this has to be repaired by an appropriate rotation after which the subtree has the same height as before (and its root the balance factor 0).
//
//    The time required is O(log n) for lookup, plus a maximum of O(log n) retracing levels (O(1) on average) on the way back to the root, so the operation can be completed in O(log n) time.

}
