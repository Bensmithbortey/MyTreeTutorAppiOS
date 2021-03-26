//
//  DiagramDetail.swift
//  MyTreeTutorApp (iOS)
//
//  Created by Benjamin-Smith Bortey on 18/03/2021.
//

import SwiftUI
import Combine

struct TreeDetail: View {

    var treeType: TreeType?
    
    var tree: Tree<Unique<Int>>?
    var treeName: String?
    
    @State var treeTypeSelection: String = TreeType.binary.rawValue
    
    var selectedTreeType: TreeType {
        return  TreeType(rawValue: treeTypeSelection)!
    }
    
    var body: some View {
        VStack {
            
            Picker(selection: $treeTypeSelection, label: Text("")) {
                ForEach(TreeType.allCases, id: \.id) { treeType in
                    Text(treeType.title).tag(treeType.rawValue)
                }
            }.pickerStyle(SegmentedPickerStyle())
            
            switch selectedTreeType {
            case .binary:
                BinaryTreeView(tree: tree, treeName: treeName)
            default:
                Spacer()
            }

        }.padding()
    }
}

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
            .background(Circle().fill(Color(.TreeBackground)))
            .padding(10)
    }
}

extension Tree where A == Unique<Int> {
    
    mutating func insert(_ number: Int) {
//        if number == value.value {
            // Do nothing - the number is already in the Tree
//        } else
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
    
    mutating func delete(_ id: A.ID) {
        for index in 0..<children.count {
            let child = children[index]
            if child.value.id == id {
                children.remove(at: index)
                break
            }
        }
        
        for index in 0..<children.count {
            children[index].delete(id)
        }
    }
    
//    mutating func delete(_ number: Int) {
//        if number < value.value {
//            if children.count > 0 {
//                if children[0].value.value == number {
//                    children.remove(at: 0)
//                } else {
//                    children[0].delete(number)
//                }
//            } else {
//                // Nothing
//            }
//        } else {
//            if children.count == 2 {
//                if children[1].value.value == number {
//                    children.remove(at: 1)
//                } else {
//                    children[1].delete(number)
//                }
//            } else if children.count == 1 {
//                if children[0].value.value == number {
//                    children.remove(at: 0)
//                } else {
//                    children[0].delete(number)
//                }
//            } else {
//                // Nothing
//            }
//        }
//    }
}


struct BinaryTreeView: View {
    
    @State var tree: Tree<Unique<Int>>? = nil
    
    @State var insertValue: String = ""
    @State var findValue: String = ""
    @State var generateMinValue: String = ""
    @State var generateMaxValue: String = ""
    
    @State var selectedNodeID: UUID?
    
    @State var history = [Int]()
    
    @State var showsOptionToGenerate = false
    
    @State var treeName: String?
    
    var body: some View {
        VStack {
            
            ScrollView {
                VStack {
                    
                    HStack {
                        Spacer()
                        
                        Button("Save", action: {
                            if let treeName = treeName {
                                try? tree?.insertToCoreData(moc: PersistenceController.shared.container.viewContext, title: treeName)
                            } else {
                                let alert = UIAlertController(title: "Choose title", message: "", preferredStyle: .alert)
                                
                                alert.addTextField { textField in
                                    //
                                }
                                
                                alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak alert] _ in
                                    if let textField = alert?.textFields?.first, let text = textField.text, !text.isEmpty {
                                        treeName = text
                                        try? tree?.insertToCoreData(moc: PersistenceController.shared.container.viewContext, title: text)
                                    } else {
                                        // Couldn't save because the title is missing
                                    }
                                }))
                                
                                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                                
                                UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
                            }
                        })
                    }
                    
                    if let tree = tree {
                        BinaryDiagram(tree: tree, node: { value in
                            
                            Text("\(value.value)")
                                .foregroundColor(Color(.TreeOutline))
                                .roundedCircle()
                                .overlay(
                                    Circle()
                                        .stroke()
                                        .foregroundColor((selectedNodeID != nil ? value.id == selectedNodeID! : false) ?
                                                            Color(.TreeOutline) : .clear)
                                )
                                .onTapGesture {
                                    if selectedNodeID == value.id {
                                        selectedNodeID = nil
                                    } else {
                                        selectedNodeID = value.id
                                    }
                                }
                        })
                    } else {
                        Button {
                            generate(min: 1, max: 100)
                        } label: {
                            Text("Generate a Tree")
                        }

                    }
                }//: VStack
            }//: ScrollView
            
            toolboxView
        }// Outer VStack
//        .alert(isPresented: $showsOptionToGenerate) {
//            Alert(title: Text("Generate a Tree?"), primaryButton: .default(Text("Generate Random Tree!"), action: {
//                generate(min: 1, max: 100)
//            }), secondaryButton: .default(Text("Start from scratch"), action: {
//                // Do nothing
//            }))
//        }
        .onAppear {
            showsOptionToGenerate = true
        }
    }
    
    @ViewBuilder
    var toolboxView: some View {
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
                        let ids = tree?.findIDs(value: Unique(value)) ?? []
                        self.selectedNodeID = ids.first
                    }
                }
            } label: {
                Text("Find")
            }
        }
        
        //
        HStack {
            Button {
                withAnimation(.default) {
                    
                }
            } label: {
                Text("Balance")
            }
        }
        
        //
        HStack {
            Text("Generate sorted Array")
            
            Button {
                withAnimation(.default) {
                    
                }
            } label: {
                Text("In Order")
            }
        }
        
        deleteButton
    }
    
    var deleteButton: some View {
        // Delete
        HStack {
            
            Button {
                
                withAnimation(.default) {
                    if let selectedNodeID = selectedNodeID {
                        
                        if let tree = tree, tree.value.id == selectedNodeID {
                            self.tree = nil
                        } else {
                            tree?.delete(selectedNodeID)
                        }
                        self.selectedNodeID = nil
                    }
                }
            } label: {
                Text("Delete")
            }
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
