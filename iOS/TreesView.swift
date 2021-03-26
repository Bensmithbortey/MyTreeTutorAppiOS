//
//  TreesView.swift
//  MyTreeTutorApp (iOS)
//
//  Created by Benjamin-Smith Bortey on 17/03/2021.
//

import SwiftUI

struct TreesView: View {
    
    @Binding var selectedTreeType: TreeType?
    
    let onSelect: () -> Void
    
    var body: some View {
        ScrollView {
            LazyVGrid(
                columns: [GridItem(.adaptive(minimum: 160), spacing: 16)],
                spacing: 16) {
                ForEach(TreeType.allCases) { treeType in
                    Group {
                        #if os(iOS)
                        TreeItem(treeType: treeType)
                            .frame(maxHeight: 240)
                        #else
                        TreeItem(treeType: treeType)
                            .frame(maxHeight: 340)
                        #endif
                    }
                    .onTapGesture {
                        selectedTreeType = treeType
                        onSelect()
                    }
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
