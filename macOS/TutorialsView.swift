//
//  TutorialsView.swift
//  MyTreeTutorApp (macOS)
//
//  Created by Benjamin-Smith Bortey on 03/03/2021.
//

import SwiftUI

struct TutorialsView: View {
    var body: some View {
        NavigationView {
            List {
                content
            }
            .frame(width: 300)
            .navigationTitle("Tutorials")
        }
    }
    
    var content: some View {
        ForEach(tutorials) { tutorial in
            NavigationLink(destination: TutorialDetail(tutorial: tutorial)) {
                TutorialRow(tutorial: tutorial)
                    .padding(.top, 12)
            }
        }
    }
}

struct TutorialsView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialsView()
    }
}
