//
//  Diagrams.swift
//  MyTreeTutorApp (iOS)
//
//  Created by Benjamin-Smith Bortey on 18/03/2021.
//

import Foundation
//
//  Diagrams.swift
//  DiagramsSample
//
//  Created by Chris Eidhof on 16.12.19.
//  Copyright © 2019 objc.io. All rights reserved.
//


import SwiftUI
/// A simple Tree datastructure that holds nodes with `A` as the value.
class Tree<A> {
    var height = 0
    var value: A
    var children: [Tree<A>] = []
    weak var parent: Tree<A>?
    
    init(_ value: A, children: [Tree<A>] = []) {
        self.value = value
        self.children = children
        for child in children {
            child.parent = self
        }
    }
}

extension Tree {
    func map<B>(_ transform: (A) -> B) -> Tree<B> {
        return Tree<B>(transform(value), children: children.map({ $0.map(transform) }))
    }
}

class Unique<A: Comparable>: Identifiable, Comparable, Equatable {
    let value: A
    init(_ value: A) { self.value = value }

    static func < (lhs: Unique<A>, rhs: Unique<A>) -> Bool {
        return lhs.value < rhs.value
    }
    
    static func == (lhs: Unique<A>, rhs: Unique<A>) -> Bool {
        return lhs.value == rhs.value
    }
    
    var id = UUID()
}

struct CollectDict<Key: Hashable, Value>: PreferenceKey {
    static var defaultValue: [Key:Value] { [:] }
    static func reduce(value: inout [Key:Value], nextValue: () -> [Key:Value]) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}

/// This is needed to use `CGPoint` as animatable data
extension CGPoint: VectorArithmetic {
    public static func -= (lhs: inout CGPoint, rhs: CGPoint) {
        lhs = lhs - rhs
    }
    public static func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    public static func += (lhs: inout CGPoint, rhs: CGPoint) {
        lhs = lhs + rhs
    }
    public mutating func scale(by rhs: Double) {
        x *= CGFloat(rhs)
        y *= CGFloat(rhs)
    }
    public static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    public var magnitudeSquared: Double { return Double(x*x + y*y) }
}
/// Draws an edge from `from` to `to`
struct Line: Shape {
    var from: CGPoint
    var to: CGPoint
    var animatableData: AnimatablePair<CGPoint, CGPoint> {
        get { AnimatablePair(from, to) }
        set {
            from = newValue.first
            to = newValue.second
        }
    }
    func path(in rect: CGRect) -> Path {
        Path { p in
            p.move(to: self.from)
            p.addLine(to: self.to)
        }
    }
}
/// A simple Diagram. It's not very performant yet, but works great for smallish trees.
struct Diagram<A: Identifiable, V: View>: View {
    let tree: Tree<A>
    let node: (A) -> V
    
    typealias Key = CollectDict<A.ID, Anchor<CGPoint>>
    var body: some View {
        VStack(alignment: .center) {
            node(tree.value)
                .anchorPreference(key: Key.self, value: .center, transform: {
                    [self.tree.value.id: $0]
                })
            HStack(alignment: .bottom, spacing: 10) {
                ForEach(tree.children, id: \.value.id, content: { child in
                    Diagram(tree: child, node: self.node)
                })
            }
        }.backgroundPreferenceValue(Key.self, { (centers: [A.ID: Anchor<CGPoint>]) in
            GeometryReader { proxy in
                ForEach(self.tree.children, id: \.value.id, content: {
                    child in
                    Line(
                        from: proxy[centers[self.tree.value.id]!],
                        to: proxy[centers[child.value.id]!])
                        .stroke()
                })
            }
        })
    }
}


/// A simple Diagram. It's not very performant yet, but works great for smallish trees.
struct BinaryDiagram<V: View>: View {
    let tree: Tree<Unique<Int>>
    let node: (Unique<Int>) -> V
    
    typealias Key = CollectDict<Unique<Int>.ID, Anchor<CGPoint>>
    var body: some View {
        VStack(alignment: .center) {
            node(tree.value)
                .anchorPreference(key: Key.self, value: .center, transform: {
                    [self.tree.value.id: $0]
                })
           
            let treeNodeWidth = CGFloat(tree.maxHorizontalDistanceLevelOrder()) / 2 * 50
            
            HStack(alignment: .top, spacing: 10) {
                
                if tree.children.count == 1 {
                    let child = tree.children[0]
                    let value = child.value
                    if value < tree.value {
                        
                        HStack(alignment: .bottom, spacing: 10) {
                            BinaryDiagram(tree: child, node: self.node)
                            Rectangle()
                                .frame(width: treeNodeWidth)
                                .foregroundColor(.clear)
                        }
                    } else {
                        
                        HStack(alignment: .bottom, spacing: 10) {
                            Rectangle()
                                .frame(width: treeNodeWidth)
                                .foregroundColor(.clear)
                            BinaryDiagram(tree: child, node: self.node)
                        }
                    }
                } else {
                    ForEach(tree.children, id: \.value.id, content: { child in
                        BinaryDiagram(tree: child, node: self.node)
                    })
                }
            }
//            .overlay(
//                Rectangle()
//                    .stroke()
//                    .foregroundColor(.black)
//            )
        }.backgroundPreferenceValue(Key.self, { (centers: [Unique<Int>.ID: Anchor<CGPoint>]) in
            GeometryReader { proxy in
                ForEach(self.tree.children, id: \.value.id, content: {
                    child in
                    Line(
                        from: proxy[centers[self.tree.value.id]!],
                        to: proxy[centers[child.value.id]!])
                        .stroke(lineWidth: 3)
                })
            }
        })
    }
}

extension Tree where A: Identifiable & Equatable {
    
    func findIDs(value: A) -> [A.ID] {
        var ids = [A.ID]()
        
        if self.value == value {
            ids.append(self.value.id)
        }
        
        for child in children {
            ids += child.findIDs(value: value)
        }
        
        return ids
    }
    
}
