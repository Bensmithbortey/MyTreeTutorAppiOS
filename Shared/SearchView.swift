//
//  SearchView.swift
//  MyTreeTutorApp
//
//  Created by Benjamin-Smith Bortey on 03/03/2021.
//

import SwiftUI

struct SearchView: View {
    @State var searchText = ""
    @State var show = false
    
    @ViewBuilder
    var body: some View {
        #if os(iOS)
        content.listStyle(InsetGroupedListStyle())
        #else
        content
        #endif
    }
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(entity: TreeModel.entity(), sortDescriptors: [], predicate: NSPredicate(format: "title != nil"))
    var trees: FetchedResults<TreeModel>
    
    var filteredTrees: [TreeModel] {
        if searchText.isEmpty {
            return self.trees.filter({ _ in true })
        } else {
            let searchTextLowercased = searchText.lowercased()
            let filteredTrees = trees.filter({ model in
                let tree = model as TreeModel
                return tree.title?.lowercased().contains(searchTextLowercased) ?? false
            })
            return filteredTrees
        }
    }
    
    var content: some View {
        List {
            TextField("Search", text: $searchText)
                .font(.title3)
                .padding(8)
                .background(Color("Background 2"))
                .mask(RoundedRectangle(cornerRadius: 8, style: .continuous))
                .padding(.vertical, 8)
            
            
            ForEach(filteredTrees) { tree in
                let tree = tree as TreeModel
                
                
                #if os(iOS)
                NavigationLink(destination:
                    TreeDetail(treeType: .binary, tree: tree.generateTree(), treeName: tree.title)
                ){
                    Text(tree.title ?? "")
                        .frame(maxHeight: 240)
                }
                #else
                TreeItem(treeType: treeType)
                    .frame(maxHeight: 240)
                #endif
                
            }.onDelete { (indexSet) in
                for index in indexSet {
                    let treeIndex = Int(index)
                    let tree = filteredTrees[treeIndex]
                    viewContext.delete(tree)
                    try! viewContext.save()
                }
            }
        }
        .navigationTitle("Search")
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}

