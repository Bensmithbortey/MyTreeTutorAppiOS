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

    let treeType: TreeType

    init(tree: Tree<Unique<Int>>? = nil,
         treeName: String? = nil,
         treeType: TreeType) {
        viewModel = BinaryTreeViewModel(tree: tree, treeType: treeType)
        self.treeType = treeType
        viewModel.name = treeName
    }

    @State var algorithmSpeed: Float = 5

    @State var insertValue: String = ""
    @State var findValue: String = ""
    @State var generateMinValue: String = ""
    @State var generateMaxValue: String = ""
    
    @State var selectedNodeID: UUID?
    
    @State var showsOptionToGenerate = false

    @State var showTreeAlgorithmsView = false
    @State var showTreeStepsView = false

    private let visibleMenuSize: CGFloat = 44


    var body: some View {
        ZStack {

            VStack {
                graphView
                    .frame(maxHeight: .infinity)

                arrayView

                toolboxView
            }.frame(width: UIScreen.main.bounds.size.width)

            VStack {
                HStack {
                    treeAlgorithmsView

                    Spacer()

                    VStack(alignment: .trailing) {

                        HStack {
                            Spacer()

                            Button {
                                let alert = UIAlertController(title: "Instructions", message: "First select the type of tree you wish to work with. You have two options: - to add your nodes or generate a random tree. If you want to ‘insert a mode’ type the number in and then insert button. To delete a node, click on the node and then press delete. Generate tree button will generate a random tree for you. If you wish to clear the tree, click clear tree. To run a Tree Algorithm on the tree after you have created it. Click tree Algorithms and select the algorithm you would like to use. It will run and show you how the algorithm is performed.", preferredStyle: .alert)
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

                    if viewModel.tree == nil {
                        viewModel.generate(min: 1, max: 100)
                    }
                }
            }
        }//: ZStack
    }

    @ViewBuilder
    var arrayView: some View {
        if viewModel.selectedAlgorithm != nil && !viewModel.arraySteps.isEmpty {
            VStack {
                Text("Array values")

                HStack {
                    ForEach(viewModel.arraySteps) { step in
                        Text("\(step.node?.value.value ?? 0)")
                            .foregroundColor(viewModel.selectedAlgorithmStep?.id == step.id ? .yellow : .black)
                    }
                }
                .animation(.easeIn)
            }
        } else {
            EmptyView()
        }
    }

    @ViewBuilder
    var algorithmStepView: some View {

        let direction = viewModel.selectedAlgorithmStep?.direction ?? .none
        let isSelection = viewModel.selectedAlgorithmStep == nil

        if let selectedAlgorithm = viewModel.selectedAlgorithm {
            VStack {


                if selectedAlgorithm == .inOrder {

                    Text("inOrder(left)")
                        .foregroundColor(direction.isLeft ? .yellow : .black)
                    Text("visit this")
                        .foregroundColor(direction == .none && isSelection ? .yellow : .black)
                    Text("inOrder(right)")
                        .foregroundColor(direction.isRight ? .yellow : .black)

                    Text("This is a post order text, lorem ipsum dolorem amet")
                        .lineLimit(nil)
                }

                if selectedAlgorithm == .preOrder {

                    Text("visit this")
                        .foregroundColor(direction == .none && isSelection ? .yellow : .black)
                    Text("preOrder(left)")
                        .foregroundColor(direction.isLeft ? .yellow : .black)
                    Text("preOrder(right)")
                        .foregroundColor(direction.isRight ? .yellow : .black)

                    Text("This is a pre order text, lorem ipsum doloret")
                        .lineLimit(nil)
                }

                if selectedAlgorithm == .postOrder {

                    Text("postOrder(left)")
                        .foregroundColor(direction.isLeft ? .yellow : .black)
                    Text("postOrder(right)")
                        .foregroundColor(direction.isRight ? .yellow : .black)
                    Text("visit this")
                        .foregroundColor(direction == .none && isSelection ? .yellow : .black)

                    Text("This is a post order text, lorem ipsum doloret")
                        .lineLimit(nil)
                }

                ScrollView {

                    ScrollViewReader { value in

                        let selectedStepID = viewModel.selectedAlgorithmStep?.id ?? 0

                        ForEach(viewModel.algorithmSteps) { step in
                            Text("\(step.direction == .none ? "\(step.node?.value.value ?? 0)" : step.direction.description)")
                                .frame(maxWidth: .infinity)
                                .foregroundColor(selectedStepID == step.id ? .yellow : .black)
                        }

                        HStack{}
                        .onReceive(viewModel.selectedAlgorithmStep.publisher) { output in
                            if selectedStepID > 10 {
                                value.scrollTo(selectedStepID, anchor: .center)
                            }
                        }
                    }
                }//: ScrollView
            }//: Outer VStack
        }//: if let statement
        else {
            EmptyView()
        }
    }

    @ViewBuilder
    var treeStepsView: some View {
        let width: CGFloat = 200

        VStack {
            // Tree algorithms
            VStack(alignment: .leading) {
                Button(action: {
                    withAnimation {
                        showTreeStepsView.toggle()
                    }
                }, label: {
                    Image(systemName: showTreeStepsView ? .arrowForward : .arrowBackward)
                        .foregroundColor(.white)
                })
                .padding()

                VStack {
                    Text("TREE STEPS")
                        .bold()

                    algorithmStepView

                    Spacer()
                    
                    HStack {
                        Text("Slow")

                        Slider(value: $algorithmSpeed, in: 0.2...10) {
                            Text("Speed")
                        }
                        .onChange(of: algorithmSpeed, perform: { value in
                            // Whenever we change the slider's value, we also change the speed on the view model
                            // This way, the next step will be scheduled with this speed in mind
                            viewModel.speed = algorithmSpeed
                        })

                        Text("Fast")
                    }
                    .padding()
                }
                .frame(width: width)
                .frame(maxHeight: .infinity)
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
                Text(viewModel.name ?? "")
                    .font(.system(size: 24))
                    .padding(.top, 50)
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
                VStack {
                    let width: CGFloat = 40

                    BinaryDiagram(tree: tree, node: { node in
                        // Tree node
                        Text("\(node.value.value)")
                            .font(.system(size: 15))
                            .fontWeight(.bold)
                            .foregroundColor(Color(.TreeOutline))

                            .frame(width: width, height: width)
                            .background(Circle().strokeBorder(lineWidth: 3))
                            .background(Circle().fill(backgroundColor(node: node.value.id)))
//                            .overlay(
//                                HStack {
//                                    // Tree balance visualisation:
//                                    Text(node is AVLTree ? "\((node as! AVLTree).balanceFactor)" : "")
//                                        .font(.system(size: 8))
//                                    // Height visualisation:
//                                    Text("H(\(node.height))")
//                                        .font(.system(size: 8))
//                                }
//                                .foregroundColor(.blue)
//                                .offset(y: 30)
//                            )
                            .onTapGesture {
                                if selectedNodeID == node.value.id {
                                    selectedNodeID = nil
                                } else {
                                    selectedNodeID = node.value.id
                                }
                            }
                    })
                }//: VStack
            }
        }//: VStack
    }
    
    @ViewBuilder
    var toolboxView: some View {

        VStack(spacing: 30) {

            playbackToolbarView

            VStack(spacing: 30) {

                Group {
                    // Generate random Tree

                    HStack(alignment: .top, spacing: 50) {

                        VStack(alignment: .leading, spacing: 25) {

                            VStack(alignment: .leading, spacing: 12) {
                                Text("Generate random tree")
                                    .font(.title2)
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                HStack {

                                    VStack(alignment: .leading, spacing: 8) {
                                        HStack {
                                            Text("Min")
                                                .frame(width: 40, alignment: .leading)
                                            TextField("Min", text: $generateMinValue)
                                                .padding(6)
                                                .background(Color(.sRGB, white: 0.92, opacity: 1.0))
                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                        }
                                        HStack {
                                            Text("Max")
                                                .frame(width: 40, alignment: .leading)
                                            TextField("Max", text: $generateMaxValue)
                                                .padding(6)
                                                .background(Color(.sRGB, white: 0.92, opacity: 1.0))
                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                        }
                                    }
                                    .frame(width: 120)

                                    Spacer()

                                    Button {
                                        if let min = Int(generateMinValue), let max = Int(generateMaxValue) {
                                            viewModel.generate(min: min, max: max)
                                        }
                                    } label: {
                                        Text("Generate")
                                    }
                                    .buttonStyle(BigButtonStyle(foregroundColor: .white, backgroundColor: Color(.Primary), padding: 8))
                                    .frame(width: 100)
                                }
                            }


                            VStack(alignment: .leading, spacing: 12) {

                                Text("Find a node")
                                    .font(.title2)
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                // Find
                                HStack {
                                    TextField("Find a node", text: $findValue)
                                        .padding(6)
                                        .background(Color(.sRGB, white: 0.92, opacity: 1.0))
                                        .clipShape(RoundedRectangle(cornerRadius: 10))

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
                                    .buttonStyle(BigButtonStyle(foregroundColor: .white, backgroundColor: Color(.Primary), padding: 8))
                                    .frame(width: 100)
                                }
                            }
                        }

                        // Insert
                        VStack {

                            VStack(alignment: .leading, spacing: 20) {

                                HStack {
                                    TextField("Insert a node", text: $insertValue)
                                        .padding(6)
                                        .background(Color(.sRGB, white: 0.92, opacity: 1.0))
                                        .clipShape(RoundedRectangle(cornerRadius: 10))

                                    Spacer()

                                    Button {
                                        withAnimation(.default) {
                                            if let value = Int(insertValue) {
                                                viewModel.insert(value)
                                            }
                                        }
                                    } label: {
                                        Text("Insert")
                                    }
                                    .buttonStyle(BigButtonStyle(foregroundColor: .white, backgroundColor: Color(.Primary), padding: 8))
                                    .frame(width: 100)
                                }
                            }


                            HStack(spacing: 20) {
                                Text("Delete selected")
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                deleteButton
                                    .frame(width: 100)
                            }


                            HStack(spacing: 20) {
                                Button {
                                    viewModel.generate(min: 1, max: 100)
                                } label: {
                                    Text("Generate a Tree")
                                }
                                .buttonStyle(BigButtonStyle(foregroundColor: .white, backgroundColor: Color(.Primary), padding: 8))
                                .padding(.bottom, 20)

                                Button {
                                    viewModel.clear()
                                } label: {
                                    Text("Clear the Tree")
                                }
                                .buttonStyle(BigButtonStyle(foregroundColor: .white, backgroundColor: Color(.Primary), padding: 8))
                                .padding(.bottom, 20)
                            }

                            saveButton
                        }
                    }

                }

            }//: Inner VStack
            .padding()
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: Color.black.opacity(0.25), radius: 16, x: 0.0, y: 2)
        }//: Outer VStack
        .padding(.horizontal, 100)
        .padding(.vertical, 30)
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
            .buttonStyle(BigButtonStyle(foregroundColor: .white, backgroundColor: Color(.Primary), padding: 8))
        }
    }
    
    var saveButton: some View {
        Button("Save", action: {
            if let treeName = viewModel.name {
                try? viewModel.tree?.insertToCoreData(moc: PersistenceController.shared.container.viewContext, title: treeName, type: treeType)
            } else {
                let alert = UIAlertController(title: "Choose title", message: "", preferredStyle: .alert)
                
                alert.addTextField { textField in
                    //
                }
                
                alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak alert] _ in
                    if let textField = alert?.textFields?.first, let text = textField.text, !text.isEmpty {
                        viewModel.name = text
                        viewModel.objectWillChange.send()
                        do {
                            try viewModel.tree?.insertToCoreData(moc: PersistenceController.shared.container.viewContext, title: text, type: treeType)
                        } catch {
                            print("Error: \(error.localizedDescription)")
                        }
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
        BinaryTreeView(treeType: .binary)
            .previewLayout(.fixed(width: 2688, height: 1242))
    }

}
