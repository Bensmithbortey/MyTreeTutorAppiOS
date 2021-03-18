//
//  TreeDetail.swift
//  MyTreeTutorApp (iOS)
//
//  Created by Benjamin-Smith Bortey on 17/03/2021.
//

import SwiftUI
//import Combine
//
//struct TreeDetail: View {
//
//    let treeType: TreeType
//
//    let binaryViewModel = BinaryTreeViewModel()
//
//    @State var insertValue: String = ""
//    @State var findValue: String = ""
//    @State var generateMinValue: String = ""
//    @State var generateMaxValue: String = ""
//
//    var viewModel: TreeViewModel {
//        switch treeType {
//        case .binary:
//            return binaryViewModel
//        default:
//            return binaryViewModel
//        }
//    }
//
//    @ViewBuilder
//    var treeVisualization: some View {
//        switch treeType {
//        case .binary:
//            BinaryTreeVisualization(viewModel: binaryViewModel)
//        default:
//            Text("")
//        }
//    }
//
//    var body: some View {
//        VStack {
//            treeVisualization
//
//            // Delete
//            HStack {
//
//                Button {
//                    viewModel.deleteSelected()
//                } label: {
//                    Text("Delete")
//                }
//            }
//
//            // Generate random Tree
//            HStack {
//                Text("Generate\nrandom tree")
//
//                VStack {
//                    TextField("Min", text: $generateMinValue)
//                    TextField("Max", text: $generateMaxValue)
//                }
//
//                Button {
//                    if let min = Int(generateMinValue), let max = Int(generateMaxValue) {
//                        viewModel.deleteTree()
//
//                        let totalNodeCount = 9
//                        // Insert 9 random elements, thus generating the random tree
//                        for _ in 0..<totalNodeCount {
//                            let value = min + Int(arc4random() % UInt32(max - min))
//                            viewModel.insert(value: value)
//                        }
//                    }
//                } label: {
//                    Text("Generate")
//                }
//            }
//
//            // Insert
//            HStack {
//                TextField("Insert a node", text: $insertValue)
//
//                Button {
//                    if let value = Int(insertValue) {
//                        viewModel.insert(value: value)
//                    }
//                } label: {
//                    Text("Insert")
//                }
//            }
//
//            // Find
//            HStack {
//                TextField("Find a node", text: $findValue)
//
//                Button {
//                    if let value = Int(findValue) {
//                        viewModel.selectNode(value: value)
//                    }
//                } label: {
//                    Text("Find")
//                }
//            }
//
//        }.padding()
//    }
//}
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
