//
//  TutorialsView.swift
//  MyTreeTutorApp (iOS)
//
//  Created by Benjamin-Smith Bortey on 03/03/2021.
//

import SwiftUI

struct TutorialsView: View {
    var body: some View {
        ScrollView {
            LazyVGrid(
                columns: [GridItem(.adaptive(minimum: 160), spacing: 16)],
                spacing: 16) {
                ForEach(tutorials) { tutorial in
                    #if os(iOS)
                    NavigationLink(destination: TutorialDetail(tutorial: tutorial)) {
                        TutorialItem(tutorial: tutorial)
                            .frame(maxHeight: 240)
                    }
                    #else
                    TutorialItem(tutorial: tutorial)
                        .frame(maxHeight: 240)
                    #endif
                }
            }
            .padding()
            
            SectionTitle(title: "Recent tutorials")
            TutorialContent()
        }
        .navigationTitle("Tree Visualiser")
    }
}

struct TutorialsView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialsView()
    }
}

