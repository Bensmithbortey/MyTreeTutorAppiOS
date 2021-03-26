//
//  BinaryTreeView.swift
//  MyTreeTutorApp (iOS)
//
//  Created by Benjamin-Smith Bortey on 26/03/2021.
//

import SwiftUI

enum TreeAlgorithm: String, Identifiable, CaseIterable {
    var id: String { rawValue }
    
    case inOrder = "In-Order",
         preOrder = "Pre-Order",
         postOrder = "Post-Order"
}

extension Tree where A == Unique<Int> {

    func generateSteps(algorithm: TreeAlgorithm) -> [AlgorithmStep] {

        var steps = [AlgorithmStep]()

        switch algorithm {
        case .preOrder:
            steps.append(AlgorithmStep(node: self))
            steps += left()?.generateSteps(algorithm: algorithm) ?? []
            steps += right()?.generateSteps(algorithm: algorithm) ?? []
        case .inOrder:
            steps += left()?.generateSteps(algorithm: algorithm) ?? []
            steps.append(AlgorithmStep(node: self))
            steps += right()?.generateSteps(algorithm: algorithm) ?? []
        case .postOrder:
            steps += left()?.generateSteps(algorithm: algorithm) ?? []
            steps += right()?.generateSteps(algorithm: algorithm) ?? []
            steps.append(AlgorithmStep(node: self))
        }

        return steps
    }

}

struct AlgorithmStep: Identifiable {
    var id = UUID()
    let node: Tree<Unique<Int>>?
}

class BinaryTreeViewModel: ObservableObject {
    @Published var tree: Tree<Unique<Int>>?

    @Published var selectedAlgorithm: TreeAlgorithm?
    @Published var algorithmSteps = [AlgorithmStep]()
    @Published var selectedAlgorithmStep: AlgorithmStep?

    private var timer: Timer?
    private var algorithmStepIndex = 0

    init(tree: Tree<Unique<Int>>?) {
        self.tree = tree
    }

    func generateSteps() {
        timer?.invalidate()

        guard let algorithm = selectedAlgorithm else { return }
        algorithmSteps = tree?.generateSteps(algorithm: algorithm) ?? []

        algorithmStepIndex = 0

        if !algorithmSteps.isEmpty {
            timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true, block: { _ in

                self.selectedAlgorithmStep = self.algorithmSteps[self.algorithmStepIndex]
                self.algorithmStepIndex += 1
                if self.algorithmStepIndex == self.algorithmSteps.count {
                    self.timer?.invalidate()
                }
            })
        }
    }
}


struct BinaryTreeView: View {

    @ObservedObject var viewModel: BinaryTreeViewModel

    init(tree: Tree<Unique<Int>>? = nil, treeName: String? = nil) {
        viewModel = BinaryTreeViewModel(tree: tree)
        self.treeName = treeName
    }
    
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
            
            graphView
            
            HStack {
                
                VStack {
                    Text(treeName ?? "")
                        .font(.system(size: 24))
                    
                    Spacer()
                    
                    // Tree algorithms
                    VStack {
                        Text("Tree Alhorithms")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                            .padding(25)
                        
                        VStack(alignment: .leading) {
                            Text(viewModel.selectedAlgorithm?.rawValue ?? "")
                            
                            ForEach(TreeAlgorithm.allCases, id: \.id) { algorithm in
                                
                                Text(algorithm.rawValue)
                                    .font(.system(size: 24, weight: .semibold))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading)
                                    .padding(.vertical, 10)
                                    .foregroundColor(.white)
                                    .onTapGesture {
                                        viewModel.selectedAlgorithm = algorithm
                                    }
                                
                                if algorithm != TreeAlgorithm.allCases.last! {
                                    Rectangle()
                                        .foregroundColor(.white)
                                        .frame(height: 0.5)
                                }
                            }
                        }
                        .frame(width: 200)
                        .padding(.bottom, 25)
                    }
                    .background(Color.blue)
                    .overlay(
                        Rectangle()
                            .stroke()
                            .foregroundColor(.black)
                    )
                }
                
                VStack {
                    Spacer()
                    
                    toolboxView
                }
                
                VStack {
                    Text("Tree Steps")

                    ForEach(viewModel.algorithmSteps) { step in
                        Text("- \(step.node?.value.value ?? 0)")
                            .foregroundColor(viewModel.selectedAlgorithmStep?.id == step.id ? .blue : .black)
                    }
                }
                .frame(width: 300)
            }//: Outer HStack
            .onAppear {
                showsOptionToGenerate = true
            }
            
        }//: ZStack
    }
    
    func color(node: UUID) -> Color {
        if let highlightedNodeID = viewModel.selectedAlgorithmStep?.node?.value.id,
           highlightedNodeID.uuidString == node.uuidString {
            return Color(.yellow)
        }
        
        if let selectedNodeID = selectedNodeID, selectedNodeID == node {
            return Color(.TreeOutline)
        }
        return .clear
    }
    
    @ViewBuilder
    var graphView: some View {
        
        VStack {
            
            if let tree = viewModel.tree {
                GeometryReader { geometry in
                    
                    let treeNodeWidth = CGFloat(tree.maxHorizontalDistanceLevelOrder())
                    let treeWidth = treeNodeWidth * 50 + (treeNodeWidth - 1) * 10
                    
                    VStack {
                        BinaryDiagram(tree: tree, node: { value in
                            // Tree node
                            Text("\(value.value)")
                                .font(.system(size: 15))
                                .foregroundColor(Color(.TreeOutline))
                                .roundedCircle()
                                .overlay(
                                    Circle()
                                        .stroke()
                                        .foregroundColor(color(node: value.id))
                                )
                                .onTapGesture {
                                    if selectedNodeID == value.id {
                                        selectedNodeID = nil
                                    } else {
                                        selectedNodeID = value.id
                                    }
                                }
                        })

                        Text("treeNodeWidth: \(Int(treeNodeWidth))")
                        Text("treeWidth: \(Int(treeWidth))")
                    }
                }
            } else {
                Button {
                    generate(min: 1, max: 100)
                } label: {
                    Text("Generate a Tree")
                }
                .roundedOutline()
            }
        }//: VStack
    }
    
    @ViewBuilder
    var toolboxView: some View {
        VStack(spacing: 30) {
            
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
                            if let tree = viewModel.tree {
                                tree.insert(value)
                            } else {
                                viewModel.tree = Tree(Unique(value))
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
                            let ids = viewModel.tree?.findIDs(value: Unique(value)) ?? []
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
                        viewModel.generateSteps()
                    }
                } label: {
                    Text("In Order")
                }
            }
            
            deleteButton
            
        }
    }
    
    var deleteButton: some View {
        // Delete
        HStack {
            
            Button {
                
//                withAnimation(.default) {
                    if let selectedNodeID = selectedNodeID {
                        
                        if let tree = viewModel.tree, tree.value.id == selectedNodeID {
                            viewModel.tree = nil
                        } else {
                            viewModel.tree?.delete(selectedNodeID)
                        }
                        self.selectedNodeID = nil
                    }
//                }
            } label: {
                Text("Delete")
            }
        }
    }
    
    func generate(min: Int, max: Int, totalNodeCount: Int = 8) {
        let value = min + Int(arc4random() % UInt32(max - min))
        viewModel.tree = Tree(Unique(value))
        
        // Insert 9 random elements, thus generating the random tree
        for _ in 0..<totalNodeCount {
            let value = min + Int(arc4random() % UInt32(max - min))
            viewModel.tree?.insert(value)
        }
    }
    
    var saveButton: some View {
        Button("Save", action: {
            if let treeName = treeName {
                try? viewModel.tree?.insertToCoreData(moc: PersistenceController.shared.container.viewContext, title: treeName)
            } else {
                let alert = UIAlertController(title: "Choose title", message: "", preferredStyle: .alert)
                
                alert.addTextField { textField in
                    //
                }
                
                alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak alert] _ in
                    if let textField = alert?.textFields?.first, let text = textField.text, !text.isEmpty {
                        treeName = text
                        try? viewModel.tree?.insertToCoreData(moc: PersistenceController.shared.container.viewContext, title: text)
                    } else {
                        // Couldn't save because the title is missing
                    }
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                
                UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
            }
        })//: Save button
        .roundedOutline()
    }
}


struct BinaryTreeView_Previews: PreviewProvider {
    static var previews: some View {
        BinaryTreeView()
            .previewLayout(.fixed(width: 2688, height: 1242))
    }
}
