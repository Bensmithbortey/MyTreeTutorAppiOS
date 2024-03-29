//
//  Tree+Unique.swift
//  MyTreeTutorApp (iOS)
//
//  Created by Benjamin-Smith Bortey on 26/03/2021.
//

import Foundation

// Binary tree
extension Tree where A == Unique<Int> {
    
    func left() -> Tree<A>? {
        if children.count == 2 {
            // We've got two children, so the first one is the lower one
            return children[0]
        } else if children.count == 1 {
            if children[0].value.value > value.value {
                return nil
            } else {
                return children[0]
            }
        } else {
            return nil
        }
    }
    
    func right() -> Tree<A>? {
        if children.count == 2 {
            return children[1]
        } else if children.count == 1 {
            if children[0].value.value > value.value {
                return children[0]
            } else {
                return nil
            }
        } else {
            return nil
        }
    }

    @discardableResult
    func insertSimple(_ number: Int) -> Tree<A> {
        return insertSimple(Tree(Unique(number)))
    }

    @discardableResult
    func insertSimple(_ node: Tree<A>) -> Tree<A> {

        if node.value.value < value.value {
            if let left = left() {
                left.insertSimple(node)
            } else {
                children.insert(node, at: 0)
                node.parent = self

                // Increasing height?
                if children.count == 1 {
                    height += 1
                    node.incrementHeightOfAncestors()
                }
            }
        } else {
            if children.count == 2 {
                children[1].insertSimple(node)
            } else if children.count == 1, let right = right() {
                right.insertSimple(node)
            } else {
                children.append(node)
                node.parent = self

                // Increasing height?
                if children.count == 1 {
                    height += 1
                    node.incrementHeightOfAncestors()
                }
            }
        }

        return self
    }

    func incrementHeightOfAncestors() {
        if let parent = parent {
            parent.recalculateHeight()
            parent.incrementHeightOfAncestors()
        }
    }

    func recalculateHeight() {
        height = max(leftHeight, rightHeight) + 1
    }

    func findRoot() -> Tree<A> {
        var root = self
        while root.parent != nil {
            root = root.parent!
        }
        return root
    }
    
    func delete(_ id: A.ID) {
        for index in 0..<children.count {
            let child = children[index]
            if child.value.id == id {
                children.remove(at: index)
                for node in [child.left(), child.right()].compactMap({ $0 }) {
                    findRoot().insertSimple(node)
                }
                return
            }
        }
        
        for index in 0..<children.count {
            children[index].delete(id)
        }
    }
    
    // Function to find the maximum width of the tree
    // using level order traversal
    func maxWidthLevelOrder() -> Int {
        // Initialize result
        var result = 0
      
        // Do Level order traversal keeping track of number
        // of nodes at every level.
        var q = [Tree]()
        q.append(self)
        
        while (!q.isEmpty) {
            // Get the size of queue when the level order
            // traversal for one level finishes
            var count = q.count
      
            // Update the maximum node count value
            result = max(count, result);
      
            // Iterate for all the nodes in the queue currently
            while (count > 0) {
                count -= 1
                
                // Dequeue an node from queue
                let temp = q.last
                q.removeLast()
      
                // Enqueue left and right children of
                // dequeued node
                if let tree = temp?.left() {
                    q.append(tree)
                }
                if let tree = temp?.right() {
                    q.append(tree)
                }
            }
        }
      
        return result
    }
    
    // Function to find the maximum width of the tree
    // using level order traversal
    func maxHorizontalDistanceLevelOrder() -> Int {
        // Initialize result
        var minimumLeft = 0
        var maximumRight = 0
      
        // Do Level order traversal keeping track of number
        // of nodes at every level.
        var queue = [TreeHorizontalDistance]()
        queue.append(TreeHorizontalDistance(tree: self, distance: 0))
        
        while (!queue.isEmpty) {
            // Get the size of queue when the level order
            // traversal for one level finishes
            var count = queue.count
      
            // Iterate for all the nodes in the queue currently
            while (count > 0) {
                count -= 1
                
                // Dequeue an node from queue
                let temp = queue.last
                queue.removeLast()
      
                guard let tempDistance = temp else { break }
                
                if minimumLeft > tempDistance.distance {
                    minimumLeft = tempDistance.distance
                }
                
                if maximumRight < tempDistance.distance {
                    maximumRight = tempDistance.distance
                }
                
                // Enqueue left and right children of
                // dequeued node
                if let tree = tempDistance.tree.left() {
                    queue.append(TreeHorizontalDistance(tree: tree, distance: tempDistance.distance - 1))
                }
                if let tree = tempDistance.tree.right() {
                    queue.append(TreeHorizontalDistance(tree: tree, distance: tempDistance.distance + 1))
                }
            }
        }
      
        return max(maximumRight, -minimumLeft) * 2
    }

    var dynamicHeight: Int {
        let leftHeight = left()?.dynamicHeight ?? 0
        let rightHeight = right()?.dynamicHeight ?? 0

        if (leftHeight > rightHeight){
            return(leftHeight+1)
        }
        else {
            return(rightHeight+1)
        }
    }

    var rightHeight: Int {
        return right()?.height ?? 0
    }

    var leftHeight: Int {
        return left()?.height ?? 0
    }

    var isLeft: Bool {
        if let parentLeft = parent?.left(), parentLeft.value.id == self.value.id {
            return true
        } else {
            return false
        }
    }

    var isRight: Bool {
        if let parentRight = parent?.right(), parentRight.value.id == self.value.id {
            return true
        } else {
            return false
        }
    }

    var hasLeft: Bool {
        return left() != nil
    }

    var hasRight: Bool {
        return right() != nil
    }

    func setRight(_ node: Tree<A>) {
        if hasRight {
            let index = hasLeft ? 1 : 0

            // Overriding: Remove the parent if needed
            if children[index].parent?.value.id == self.value.id {
                children[index].parent = nil
            }
            children.remove(at: index)
        }

        children.append(node)
        node.parent = self
    }

    func setLeft(_ node: Tree<A>) {
        if hasLeft {
            // Overriding: Remove the parent if needed
            if children[0].parent?.value.id == self.value.id {
                children[0].parent = nil
            }
            children.remove(at: 0)
        }

        children.insert(node, at: 0)
        node.parent = self
    }
}

struct TreeHorizontalDistance {
    let tree: Tree<Unique<Int>>
    let distance: Int
}
