//
//  BinaryTreeView.swift
//  MyTreeTutorApp (iOS)
//
//  Created by Benjamin-Smith Bortey on 26/03/2021.
//

import SwiftUI
import Combine

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
    
    @State var showsOptionToGenerate = false
    
    @State var treeName: String?

    @State var showTreeAlgorithmsView = false
    @State var showTreeStepsView = false

    private let visibleMenuSize: CGFloat = 44


    var body: some View {
        ZStack {

            VStack {
                graphView
                    .frame(width: 400, height: 400)

                toolboxView
            }

            VStack {
                HStack {
                    treeAlgorithmsView

                    Spacer()

                    VStack(alignment: .trailing) {

                        HStack {
                            Spacer()

                            Button {
                                let alert = UIAlertController(title: "Instructions", message: "Here are instructions on how to use the app", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "Got it", style: .cancel, handler: nil))

                                UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
                            } label: {
                                Image(systemName: .infoCircleFill)
                            }
                        }.padding()

                        Spacer()

                        treeStepsView
                    }
                }//: Outer HStack
                .onAppear {
                    showsOptionToGenerate = true
                }
            }
        }//: ZStack
    }

    @ViewBuilder
    var treeStepsView: some View {
        let width: CGFloat = 200

        VStack {
            // Tree algorithms
            VStack(alignment: .leading) {
                Button(action: {
                    showTreeStepsView.toggle()
                }, label: {
                    Image(systemName: showTreeStepsView ? .arrowForward : .arrowBackward)
                        .foregroundColor(.white)
                })
                .padding()

                VStack {
                    Text("Tree Steps")

                    ScrollView {
                        VStack {
                            ForEach(viewModel.algorithmSteps) { step in
                                Text("- \(step.node?.value.value ?? 0)")
                                    .foregroundColor(viewModel.selectedAlgorithmStep?.id == step.id ? .yellow : .black)
                            }
                        }
                    }
                }
                .frame(width: width, height: 300)
                .opacity(showTreeStepsView ? 1 : 0)
                .overlay(
                    HStack {
                        Text("Tree Steps")
                            .foregroundColor(.white)
                            .rotationEffect(Angle(degrees: 270))
                            .offset(x: -20)
                            .opacity(showTreeStepsView ? 0 : 1)

                        Spacer()
                    }
                )
            }
            .squaredOutline()
        }
        .offset(x: showTreeStepsView ? 0 : width - visibleMenuSize)
        .animation(.easeIn)
    }

    @ViewBuilder
    var playbackToolbarView: some View {

        let imageSide: CGFloat = 20

        HStack(spacing: imageSide) {

            Button(action: {
                viewModel.stepBackward()
            }, label: {
                Image(systemName: .backwardEnd)
                    .resizable()
                    .frame(width: imageSide, height: imageSide)
            })

            Button(action: {
                if viewModel.isPlayingAlgorithm {
                    viewModel.pause()
                } else {
                    viewModel.resume()
                }
            }, label: {
                Image(systemName: viewModel.isPlayingAlgorithm ? .pause : .play)
                    .resizable()
                    .frame(width: imageSide, height: imageSide)
            })


            Button(action: {
                viewModel.stepForward()
            }, label: {
                Image(systemName: .forwardEnd)
                    .resizable()
                    .frame(width: imageSide, height: imageSide)
            })

        }
        .foregroundColor(.black)
    }

    @ViewBuilder
    var treeAlgorithmsView: some View {
        let width: CGFloat = 200

        VStack {
            HStack {
                Text(treeName ?? "")
                    .font(.system(size: 24))
            }

            Spacer()

            // Tree algorithms
            VStack(spacing: 25) {

                HStack {
                    Spacer()

                    Button(action: {
                        showTreeAlgorithmsView.toggle()
                    }, label: {
                        Image(systemName: showTreeAlgorithmsView ? .arrowBackward : .arrowForward)
                            .foregroundColor(.white)
                    })
                    .padding()
                }

                VStack(spacing: 25) {
                    Text("Tree Algorithms")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)

                    VStack(alignment: .leading) {
                        ForEach(TreeAlgorithm.allCases, id: \.id) { algorithm in

                            Text(algorithm.rawValue)
                                .font(.system(size: 24, weight: .semibold))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading)
                                .padding(.vertical, 10)
                                .foregroundColor(viewModel.selectedAlgorithm == algorithm ? .yellow : .white)
                                .onTapGesture {
                                    viewModel.selectAlgorithm(algorithm)
                                    viewModel.generateSteps()
                                    showTreeStepsView = true
                                    showTreeAlgorithmsView = false
                                }

                            if algorithm != TreeAlgorithm.allCases.last! {
                                Rectangle()
                                    .foregroundColor(.white)
                                    .frame(height: 0.5)
                            }
                        }
                    }
                }
                .opacity(showTreeAlgorithmsView ? 1 : 0)
                .overlay(
                    HStack {
                        Spacer()

                        Text("Tree Algorithms")
                            .foregroundColor(.white)
                            .rotationEffect(Angle(degrees: 90))
                            .offset(x: 40)
                            .opacity(showTreeAlgorithmsView ? 0 : 1)
                    }
                )
            }
            .frame(width: width)
            .squaredOutline()
            .offset(x: showTreeAlgorithmsView ? 0 : -(width - visibleMenuSize))
            .animation(.easeIn)
        }
    }
    
    func strokeColor(node: UUID) -> Color {
        return .clear
    }

    func backgroundColor(node: UUID) -> Color {
        if let highlightedNodeID = viewModel.selectedAlgorithmStep?.node?.value.id,
           highlightedNodeID.uuidString == node.uuidString {
            return Color(.yellow)
        }
        if let selectedNodeID = selectedNodeID, selectedNodeID == node {
            return Color(.TreeSelectedBackground)
        }
        return Color(.TreeBackground)
    }
    
    @ViewBuilder
    var graphView: some View {
        
        VStack {
            
            if let tree = viewModel.tree {
                GeometryReader { geometry in
                    
                    let treeNodeWidth = CGFloat(tree.maxHorizontalDistanceLevelOrder())
                    let treeWidth = treeNodeWidth * 50 + (treeNodeWidth - 1) * 10
                    
                    VStack {
                        let width: CGFloat = 40

                        BinaryDiagram(tree: tree, node: { value in
                            // Tree node
                            Text("\(value.value)")
                                .font(.system(size: 15))
                                .fontWeight(.bold)
                                .foregroundColor(Color(.TreeOutline))

                                .frame(width: width, height: width)
                                .background(Circle().strokeBorder(lineWidth: 3))
                                .background(Circle().fill(backgroundColor(node: value.id)))
//                                .overlay(
//                                    Circle()
//                                        .stroke()
//                                        .foregroundColor(strokeColor(node: value.id))
//                                )
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
                    viewModel.generate(min: 1, max: 100)
                } label: {
                    Text("Generate a Tree")
                }
                .roundedOutline()
            }
        }//: VStack
    }
    
    @ViewBuilder
    var toolboxView: some View {
        let height: CGFloat = 250

        VStack(spacing: 30) {

            playbackToolbarView

            VStack(spacing: 30) {

                Group {
                    // Generate random Tree

                    HStack(spacing: 100) {

                        HStack {
                            Text("Generate\nrandom tree")

                            VStack {
                                TextField("Min", text: $generateMinValue)
                                TextField("Max", text: $generateMaxValue)
                            }

                            Button {
                                if let min = Int(generateMinValue), let max = Int(generateMaxValue) {
                                    viewModel.generate(min: min, max: max)
                                }
                            } label: {
                                Text("Generate")
                            }
                            .buttonStyle(BigButtonStyle(foregroundColor: .white, backgroundColor: Color(.Primary)))
                        }

                        // Insert
                        HStack {
                            TextField("Insert a node", text: $insertValue)

                            Button {
                                withAnimation(.default) {
                                    if let value = Int(insertValue) {
                                        viewModel.insert(value)
                                    }
                                }
                            } label: {
                                Text("Insert")
                            }
                        }

                    }

                    HStack(spacing: 100) {
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

                        deleteButton

                        saveButton
                    }
                }
            }
        }
        .frame(height: height)
        .padding(.horizontal, 100)
    }
    
    var deleteButton: some View {
        // Delete
        HStack {
            
            Button {
                withAnimation(.default) {
                    if let selectedNodeID = selectedNodeID {
                        viewModel.delete(selectedNodeID)
                        self.selectedNodeID = nil
                    }
                }
            } label: {
                Text("Delete")
            }
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
        .buttonStyle(BigButtonStyle(foregroundColor: .white, backgroundColor: Color(.Primary)))
    }
}


struct BinaryTreeView_Previews: PreviewProvider {
    static var previews: some View {
        BinaryTreeView()
            .previewLayout(.fixed(width: 2688, height: 1242))
    }
}
