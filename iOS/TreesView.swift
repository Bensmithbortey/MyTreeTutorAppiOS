//
//  TreesView.swift
//  MyTreeTutorApp (iOS)
//
//  Created by Benjamin-Smith Bortey on 17/03/2021.
//

import SwiftUI


enum TreeType: String, CaseIterable, Identifiable { // CaseIterable helps with converting the enum into a list
    case binary, rooted, binarySearch, avl
    
    // MARK: - Identifiable
    
    var id: String { return rawValue }
    
    // MARK: - Displayable properties
    
    var image: String { // We will use the same name for the image as the name of the case in the enum -> this way the code can be simpler
        return rawValue
    }
    
    var color: Color {
        // Same here - we will use adaptive colors so that for different appearance
        // there can be different color (dark/light mode, high contrast, etc.)
        // We can also define the colors by the enum case name - again, simpler
        return Color(rawValue)
    }
    
    var title: String {
        // Here we need to define the displayable title
        switch self {
        case .binary:
            return "Binary Tree"
        case .rooted:
            return "Rooted Tree"
        case .binarySearch:
            return "Binary Search Tree"
        case .avl:
            return "AVL Tree"
        }
    }
    
    var subtitle: String {
        // Here we need to define the displayable subtitle
        // TODO: change the strings
        switch self {
        case .binary:
            return "Binary Tree is a fancy tree"
        case .rooted:
            return "Rooted Tree is a fancy tree"
        case .binarySearch:
            return "Binary Search Tree is a fancy tree"
        case .avl:
            return "AVL Tree is a fancy tree"
        }
    }
}

struct TreesView: View {
    
    var body: some View {
        ScrollView {
            LazyVGrid(
                columns: [GridItem(.adaptive(minimum: 160), spacing: 16)],
                spacing: 16) {
                ForEach(TreeType.allCases) { treeType in
                    #if os(iOS)
                    NavigationLink(destination: TreeDetail(treeType: treeType))  {
                        TreeItem(treeType: treeType)
                            .frame(maxHeight: 240)
                    }
                    #else
                    TreeItem(treeType: treeType)
                        .frame(maxHeight: 240)
                    #endif
                }
            }
            .padding()
        }
        .navigationTitle("Tree Visualiser")
    }
}

struct TreesView_Previews: PreviewProvider {
    static var previews: some View {
//        TreesView()
        Text(TreeType.binary.title)
    }
}
