//
//  DiagramDetail.swift
//  MyTreeTutorApp (iOS)
//
//  Created by Benjamin-Smith Bortey on 18/03/2021.
//

import SwiftUI
import Combine

struct TreeDetail: View {
    
    var tree: Tree<Unique<Int>>?
    var treeName: String?

    private let availableTreeTypes: [TreeType] = [.binary, .avl]
    
    @State var treeTypeSelection: String = TreeType.binary.rawValue
    
    var selectedTreeType: TreeType {
        return  TreeType(rawValue: treeTypeSelection)!
    }
    
    var body: some View {
        VStack {
            Picker(selection: $treeTypeSelection, label: Text("")) {
                ForEach(availableTreeTypes, id: \.id) { treeType in
                    Text(treeType.title)
                        .tag(treeType.rawValue)
                }
            }.pickerStyle(SegmentedPickerStyle())
            
            switch selectedTreeType {
            case .binary:
                BinaryTreeView(tree: tree, treeName: treeName, treeType: selectedTreeType)
            case .avl:
                BinaryTreeView(tree: tree, treeName: treeName, treeType: selectedTreeType)
            default:
                Spacer()
            }

        }
    }
}

struct TreeDetail_Previews: PreviewProvider {
    static var previews: some View {
        TreeDetail()
    }
}
