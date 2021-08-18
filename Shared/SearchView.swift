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
    
    @FetchRequest(entity: TreeModel.entity(), sortDescriptors: [NSSortDescriptor(key: "isFavorite", ascending: false)], predicate: NSPredicate(format: "title != nil"))
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
                .background(Color(.Background2))
                .mask(RoundedRectangle(cornerRadius: 8, style: .continuous))
                .padding(.vertical, 8)
            
            ForEach(filteredTrees) { tree in

                HStack {
                    let tree = tree as TreeModel

                    Text(tree.title ?? "")
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Image(systemName: tree.isFavorite ? .starFill : .star)
                        .foregroundColor(.yellow)
                        .onTapGesture {
                            withAnimation {
                                tree.isFavorite.toggle()
                                try! viewContext.save()
                            }
                        }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    NotificationCenter.default.post(name: .changeTab,
                                                    object: Tab.treeVisualizer,
                                                    userInfo: [
                                                        "TreeModelNavigation": TreeModelNavigation(title: tree.title,
                                                                                                   tree: tree.generateTree(),
                                                                                                   type: tree.treeType)
                                                    ])
                }
                
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

