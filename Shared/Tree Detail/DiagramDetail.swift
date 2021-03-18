//
//  DiagramDetail.swift
//  MyTreeTutorApp (iOS)
//
//  Created by Benjamin-Smith Bortey on 18/03/2021.
//

import SwiftUI
import Combine

struct TreeDetail: View {

    let treeType: TreeType

    var body: some View {
        VStack {
            
                switch treeType {
                case .binary:
                    BinaryTreeView()
                default:
                    Text("")
                }

        }.padding()
    }
}
//
//
//struct BinaryTreeVisualization: View {
//
//    @ObservedObject var viewModel: BinaryTreeViewModel
//
//    @State private var refreshFlag = false
//
//    var body: some View {
////        GeometryReader { geometry in
//        VStack {
//            if let tree = viewModel.tree {
//                BinaryTreeView(tree: tree)
//                    .id("\(refreshFlag)")
//            }
//        }
//        .onReceive(viewModel.objectWillChange, perform: { _ in
//            refreshFlag.toggle()
//        })
//    }
//}
//
//
//struct TreeDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        TreeDetail(treeType: .binary)
//    }
//}

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

extension View {
    func roundedCircle() -> some View {
        self
            .frame(width: 50, height: 50)
            .background(Circle().stroke())
            .background(Circle().fill(Color.white))
            .padding(10)
    }
}

extension Tree where A == Unique<Int> {
    
    mutating func insert(_ number: Int) {
        if number == value.value {
            // Do nothing - the number is already in the Tree
        } else
        if number < value.value {
            if children.count > 0 {
                children[0].insert(number)
            } else {
                children.append(Tree(Unique(number)))
            }
        } else {
            if children.count == 2 {
                children[1].insert(number)
            } else if children.count == 1 && children[0].value.value > number {
                children[0].insert(number)
            } else {
                children.append(Tree(Unique(number)))
            }
        }
    }
    
    mutating func delete(_ number: Int) {
        if number < value.value {
            if children.count > 0 {
                if children[0].value.value == number {
                    children.remove(at: 0)
                } else {
                    children[0].delete(number)
                }
            } else {
                // Nothing
            }
        } else {
            if children.count == 2 {
                if children[1].value.value == number {
                    children.remove(at: 1)
                } else {
                    children[1].delete(number)
                }
            } else if children.count == 1 {
                if children[0].value.value == number {
                    children.remove(at: 0)
                } else {
                    children[0].delete(number)
                }
            } else {
                // Nothing
            }
        }
    }
}


struct BinaryTreeView: View {
    
    @State var tree: Tree<Unique<Int>>? = nil
    
    @State var insertValue: String = ""
    @State var findValue: String = ""
    @State var generateMinValue: String = ""
    @State var generateMaxValue: String = ""
    
    @State var selectedValue: Int?
    
    @State var history = [Int]()
    
    @State var showsOptionToGenerate = false
    
    var body: some View {
        VStack {
            
            ScrollView {
                VStack {
                    
                    if let tree = tree {
                        Diagram(tree: tree, node: { value in
                            
                            Text("\(value.value)")
                                .roundedCircle()
                                .overlay(
                                    Circle()
                                        .stroke()
                                        .foregroundColor((selectedValue != nil ? value.value == selectedValue! : false) ? .blue : .clear)
                                )
                                .onTapGesture {
                                    if selectedValue == value.value {
                                        selectedValue = nil
                                    } else {
                                        selectedValue = value.value
                                    }
                                }
                        })
                    }
                    
                    
                    // Delete
                    HStack {
                        
                        Button {
                            
                            withAnimation(.default) {
                                if let selectedValue = selectedValue {
                                    
                                    if let tree = tree, tree.value.value == selectedValue {
                                        self.tree = nil
                                    } else {
                                        tree?.delete(selectedValue)
                                    }
                                    self.selectedValue = nil
                                }
                            }
                        } label: {
                            Text("Delete")
                        }
                    }
                    
                    // Generate random Tree
                    HStack {
                        Text("Generate\nrandom tree")
                        
                        VStack {
                            TextField("Min", text: $generateMinValue)
                            TextField("Max", text: $generateMaxValue)
                        }
                        
                        Button {
                            if let min = Int(generateMinValue), let max = Int(generateMaxValue) {
                                generate(min: min, max: max)
                            }
                        } label: {
                            Text("Generate")
                        }
                    }
                    
                    // Insert
                    HStack {
                        TextField("Insert a node", text: $insertValue)
                        
                        Button {
                            withAnimation(.default) {
                                if let value = Int(insertValue) {
                                    if let _ = tree {
                                        self.tree?.insert(value)
                                    } else {
                                        tree = Tree(Unique(value))
                                    }
                                    history.append(value)
                                }
                            }
                        } label: {
                            Text("Insert")
                        }
                    }
                    
                    // Find
                    HStack {
                        TextField("Find a node", text: $findValue)
                        
                        Button {
                            withAnimation(.default) {
                                if let value = Int(findValue) {
                                    selectedValue = value
                                }
                            }
                        } label: {
                            Text("Find")
                        }
                    }
                }//: VStack
            }//: ScrollView
            
            HStack {
                
            }
        }
        .alert(isPresented: $showsOptionToGenerate) {
            Alert(title: Text("Generate a Tree?"), primaryButton: .default(Text("Generate Random Tree!"), action: {
                generate(min: 1, max: 100)
            }), secondaryButton: .default(Text("Start from scratch"), action: {
                // Do nothing
            }))
        }
        .onAppear {
            showsOptionToGenerate = true
        }
    }
    
    func generate(min: Int, max: Int, totalNodeCount: Int = 8) {
        let value = min + Int(arc4random() % UInt32(max - min))
        tree = Tree(Unique(value))
        
        // Insert 9 random elements, thus generating the random tree
        for _ in 0..<totalNodeCount {
            let value = min + Int(arc4random() % UInt32(max - min))
            tree?.insert(value)
        }
    }
}

struct ContentView2_Previews: PreviewProvider {
    static var previews: some View {
        BinaryTreeView()
    }
}
