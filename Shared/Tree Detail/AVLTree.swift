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

        // FIXME: put back the balancing once the insertion + rotation is debugged
//        switch balanceFactor {
//        case 2:
//            if let leftChild = left() as? AVLTree<A>,
//               leftChild.balanceFactor == -1 {
//                return leftRightRotate()
//            } else {
//                return rightRotate()
//            }
//        case -2:
//            if let rightChild = right() as? AVLTree<A>,
//               rightChild.balanceFactor == 1 {
//                return rightLeftRotate()
//            } else {
//                return leftRotate()
//            }
//        default: // -1, 0, 1
//            return self
//        }
        return self
    }


    @discardableResult
    private func leftRotate() -> AVLTree<A> {
        // Before:
        //       O
        //      / \
        //     L   R
        //        / \
        //       RL  RR

        // After:
        //       R
        //      / \
        //     O   RR
        //    / \
        //   L   RL

        // The right node is going to be the local root now (pivot)
        guard let pivot = right() as? AVLTree<A> else {
            return self
        }
        let originalParent = parent

        // The left subtree of the pivot is going to be right of the old root
        if let pivotLeft = pivot.left() {
            self.setRight(pivotLeft)
        }
        // The original root will become the left of the pivot
        pivot.setLeft(self)

        // The height has changed - let's recalculate
        self.recalculateHeight()
        pivot.recalculateHeight()

        // Replace self in parent with pivot
        if self.isLeft {
            originalParent?.setLeft(pivot)
        } else {
            originalParent?.setRight(pivot)
        }
        return pivot
    }

    @discardableResult
    private func rightRotate() -> AVLTree<A> {
        // Before:
        //       O
        //      / \
        //     L   R
        //    / \
        //   LL  RL

        // After:
        //       L
        //      / \
        //    LL   O
        //        / \
        //       LR  R

        // The left node is going to be the local root now (pivot)
        guard let pivot = left() as? AVLTree<A> else {
            return self
        }
        let originalParent = parent

        // The right subtree of the pivot is going to be left of the old root
        if let pivotRight = pivot.right() {
            setLeft(pivotRight)
        }
        // The original root will become the right of the pivot
        pivot.setRight(self)

        // The height has changed - let's recalculate
        self.recalculateHeight()
        pivot.recalculateHeight()

        // Replace self in parent with pivot
        if self.isLeft {
            originalParent?.setLeft(pivot)
        } else {
            originalParent?.setRight(pivot)
        }
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
        _ = parent?.asAVLTree?.insert(node)
    }

    func insert(_ number: Int) -> AVLTree<A> {
        return insert(AVLTree(Unique(number)))
    }

    func insert(_ node: AVLTree<A>) -> AVLTree<A> {
        super.insertSimple(node)

        return node.balanceAncestors()
    }

    /**
     Traverse the ancestors, balancing them along the way
     */
    func balanceAncestors() -> AVLTree<A> {
        if let parent = parent?.asAVLTree {
            let balancedParent = parent.balance()
            balancedParent.recalculateHeight()
            return balancedParent.balanceAncestors()
        } else {
            return self
        }
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

extension Tree where A == Unique<Int> {

    var asAVLTree: AVLTree<Unique<Int>>? {
        return self as? AVLTree<Unique<Int>>
    }

}
