//
//  TreeDetail.swift
//  MyTreeTutorApp (iOS)
//
//  Created by Benjamin-Smith Bortey on 17/03/2021.
//

import SwiftUI
import Combine

struct TreeDetail: View {
    
    let treeType: TreeType
    
    let binaryViewModel = BinaryTreeViewModel()
    
    @State var insertValue: String = ""
    
    var viewModel: TreeViewModel {
        switch treeType {
        case .binary:
            return binaryViewModel
        default:
            return binaryViewModel
        }
    }
    
    @ViewBuilder
    var treeVisualization: some View {
        switch treeType {
        case .binary:
            BinaryTreeVisualization(viewModel: binaryViewModel)
        default:
            Text("")
        }
    }
    
    var body: some View {
        VStack {
            treeVisualization
            
            HStack {
                TextField("Insert a node", text: $insertValue)
                
                Button {
                    if let value = Int(insertValue) {
                        viewModel.insert(value: value)
                    }
                } label: {
                    Text("Insert")
                }
            }

        }.padding()
    }
}


struct BinaryTreeVisualization: View {
    
    @ObservedObject var viewModel: BinaryTreeViewModel
    
    @State private var refreshFlag = false
    
    var body: some View {
//        GeometryReader { geometry in
        VStack {
            if let tree = viewModel.tree {
                BinaryTreeView(tree: tree)
                    .id("\(refreshFlag)")
            }
        }
        .onReceive(viewModel.objectWillChange, perform: { _ in
            refreshFlag.toggle()
        })
    }
}

struct BinaryTreeView: View {
    
    let tree: BinaryTree
    
    var body: some View {
        
        VStack {
            Text("\(tree.value)")
                .padding()
                .background(
                    Rectangle()
                        .foregroundColor(tree.selected ? .blue : .gray)
                )
                .clipShape(
                    Circle()
                )
                .frame(width: 60, height: 60)
                
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    if let subtree = tree.left {
                        Arrow(direction: .downLeft)
                            .stroke()
                            .foregroundColor(.black)
                            .frame(height: 20)
                        BinaryTreeView(tree: subtree)
                    } else {
                        Spacer()
                    }
                }
                //.frame(width: width)
                
                VStack(alignment: .trailing, spacing: 0) {
                    if let subtree = tree.right {
                        Arrow(direction: .downRight)
                            .stroke()
                            .foregroundColor(.black)
                            .frame(height: 20)
                        BinaryTreeView(tree: subtree)
                    } else {
                        Spacer()
                    }
                }
                //.frame(width: width)
            }
        }//: VStack
    }
}

struct Arrow: Shape {
    
    enum Direction {
        case upLeft, upRight, downLeft, downRight
    }
    
    let direction: Direction
    
    func path(in rect: CGRect) -> Path {
        
        let width = rect.width
        let height = rect.height
        
        return Path { path in
            
            switch self.direction {
            case .upLeft:
                path.addLines([
                    CGPoint(x: width, y: height),
                    CGPoint(x: 0, y: 0)
                ])
            case .upRight:
                path.addLines([
                    CGPoint(x: 0, y: height),
                    CGPoint(x: width, y: 0)
                ])
            case .downLeft:
                path.addLines([
                    CGPoint(x: width, y: 0),
                    CGPoint(x: width / 2, y: height)
                ])
            case .downRight:
                path.addLines([
                    CGPoint(x: 0, y: 0),
                    CGPoint(x: width / 2, y: height)
                ])
            }
            
            path.closeSubpath()
        }
        
    }
    
}

protocol TreeViewModel {
    func insert(value: Int)
    // TODO: delete, select, ...
}


class BinaryTreeViewModel: ObservableObject, TreeViewModel {
    
    var tree: BinaryTree?
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    func insert(value: Int) {
        if let tree = tree {
            tree.insertNode(value: value)
        } else {
            tree = BinaryTree(value: value)
        }
        objectWillChange.send()
    }
    
}



protocol Tree {
    var value: Int { set get }
    
    func insertNode(value: Int)
    func findNode(value: Int) -> Self?
    func findSelectedNode(value: Int) -> Self?
    func delete()
}

class BinaryTree: Tree, Equatable, CustomStringConvertible {
    var value: Int
    
    var selected: Bool = false
    
    var left: BinaryTree?
    var right: BinaryTree?
    weak var parent: BinaryTree?
    
    init(value: Int) {
        self.value = value
    }
    
    func insertNode(value: Int) {
        if self.value > value {
            if let tree = left {
                tree.insertNode(value: value)
            } else {
                left = BinaryTree(value: value)
                left?.parent = self
            }
        } else {
            
            if let tree = right {
                tree.insertNode(value: value)
            } else {
                right = BinaryTree(value: value)
                right?.parent = self
            }
        }
    }
    
    func findNode(value: Int) -> Self? {
        return nil
    }
    
    func findSelectedNode(value: Int) -> Self? {
        if selected {
            return self
        }
        
        if let tree = left {
            return tree.findSelectedNode(value: value) as? Self
        }
        if let tree = right {
            return tree.findSelectedNode(value: value) as? Self
        }
        
        return nil
    }
    
    func delete() {
        if parent?.left == self {
            parent?.left = nil
        } else
        if parent?.right == self {
            parent?.right = nil
        }
    }
    
    // MARK: - Equatable
    
    static func == (lhs: BinaryTree, rhs: BinaryTree) -> Bool {
        return lhs.value == rhs.value
    }
    
    var description: String {
        return "\(value)\n\(left?.description ?? "")  \(right?.description ?? "")"
    }
}

struct TreeDetail_Previews: PreviewProvider {
    static var previews: some View {
        TreeDetail(treeType: .binary)
    }
}
