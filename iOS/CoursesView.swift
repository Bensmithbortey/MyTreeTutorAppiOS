//
//  CoursesView.swift
//  MyTreeTutorApp (iOS)
//
//  Created by Benjamin-Smith Bortey on 03/03/2021.
//

import SwiftUI

extension Notification.Name {

    static let changeTab = Notification.Name("changeTab")

}

enum Tab: Int {
    case courses,
         treeVisualizer,
         search
}

struct TreeModelNavigation {
    let title: String?
    let tree: Tree<Unique<Int>>
    let type: TreeType
}

struct CoursesView: View {
    @Namespace var namespace
    @State var items = courses
    @State var show =  false
    @State var showNavBar = true
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @State var selectedTreeType: TreeType?

    @State var selectedTreeNavigation: TreeModelNavigation?
    @State var tabSelection: Int = 0
    
    var body: some View {
        ZStack {
            tabView
            fullContent
        }
        .onReceive(NotificationCenter.default.publisher(for: .changeTab), perform: { notification in
            if let tab = notification.object as? Tab {
                tabSelection = tab.rawValue
            }
            DispatchQueue.main.async {

                if let navigation = notification.userInfo?["TreeModelNavigation"] as? TreeModelNavigation {
                    selectedTreeNavigation = navigation
                }
            }
        })
    }
    
    var content: some View {
        ScrollView {
            LazyVGrid(
                columns: [GridItem(.adaptive(minimum: 159), spacing: 16)],
                spacing: 16) {
                ForEach(items.indices) { index in
                    VStack {
                        CourseItem(course: items[index], cornerRadius: show ? 10 : 22)
                            .matchedGeometryEffect(id: items[index].id, in: namespace, properties: .frame, isSource: !items[index].show)
                            .frame(maxHeight: 300)
                    }
                    .zIndex(items[index].index)
                    .onTapGesture {
                        items[index].index = Double(index)
                        items[index].show.toggle()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            show = true
                            showNavBar = false
                        }
                    }
                }
            }
            .animation(.spring(response: 0.4, dampingFraction: 0.8))
            .padding(.all, 20)
        }
    }
    
    var fullContent: some View {
        ForEach(items.indices) { index in
            if items[index].show {
                ScrollView {
                    VStack {
                        let course = items[index]
                        CourseItem(course: course, cornerRadius: show ? 10 : 22)
                            .matchedGeometryEffect(id: items[index].id, in: namespace, properties: .frame, isSource: items[index].show)
                            .frame(maxHeight: 300)
                            .zIndex(1)
                        VStack {
                            CourseSectionContent(textFileName: course.contentFileName)
                        }
                        .offset(y: show ? 0 : -100)
                        .opacity(show ? 1 : 0)
                        .zIndex(0)
                    }
                    .background(
                        Color("Background 1")
                            .opacity(show ? 1 : 0)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                }
                .frame(maxWidth: 712)
                .edgesIgnoringSafeArea(.vertical)
                .frame(maxWidth: .infinity)
                .animation(.spring(response: 0.4, dampingFraction: 0.8))
                .background(
                    BlurView()
                        .opacity(show ? 1 : 0)
                        .animation(.easeIn(duration: 0.5))
                        .edgesIgnoringSafeArea(.all)
                )
                .overlay(
                    VStack {
                        HStack {
                            Spacer()
                            CloseButton()
                                .padding(.horizontal)
                                .opacity(show ? 1 : 0)
                                .animation(.easeIn)
                                .onTapGesture {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        items[index].index = -1
                                    }
                                    items[index].show.toggle()
                                    show = false
                                    showNavBar = true
                                }
                        }
                        Spacer()
                    }
                )
            }
        }
    }
    
    @ViewBuilder
    var fullVisualizer: some View {
        ForEach(TreeType.allCases) { treeType in
            
            if treeType == selectedTreeType {
                ScrollView {
                    VStack {
                        TreeDetail()
                            .frame(maxHeight: 300)
                    }
                    .background(
                        Color("Background 1")
                            .opacity(show ? 1 : 0)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                }
                .frame(maxWidth: 712)
                .edgesIgnoringSafeArea(.vertical)
                .frame(maxWidth: .infinity)
                .animation(.spring(response: 0.4, dampingFraction: 0.8))
                .background(
                    BlurView()
                        .opacity(show ? 1 : 0)
                        .animation(.easeIn(duration: 0.5))
                        .edgesIgnoringSafeArea(.all)
                )
            }
        }
    }
    
    var tabView: some View {
        TabView(selection: $tabSelection) {

            NavigationView {
                content
                    .navigationTitle(showNavBar ? "Courses" : "")
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .tabItem { Image(systemName: "book.closed")
                Text("Courses")
            }.tag(Tab.courses.rawValue)



            VStack {
                if let tree = selectedTreeNavigation {
                    TreeDetail(tree: tree.tree,
                               treeName: tree.title,
                               treeTypeSelection: tree.type.rawValue)
                } else {
                    TreeDetail()
                }
            }
            .tabItem {
                Image(systemName: "list.bullet.rectangle")
                Text("Tree Visualiser")
            }.tag(Tab.treeVisualizer.rawValue)



            NavigationView {
                SearchView()
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .tabItem {
                Image(systemName: "magnifyingglass")
                Text("Search")
            }.tag(Tab.treeVisualizer.rawValue)
        }
    }
}

struct CoursesView_Previews: PreviewProvider {
    static var previews: some View {
        CoursesView()
    }
}
