//
//  LivestreamsView.swift
//  MyTreeTutorApp (macOS)
//
//  Created by Benjamin-Smith Bortey on 03/03/2021.
//

import SwiftUI

struct LivestreamsView: View {
    var body: some View {
        ScrollView {
            content
        }
        .frame(minWidth: 500, idealWidth: 700, maxWidth: .infinity, minHeight: 500, maxHeight: .infinity)
        .navigationTitle("Livestreams")
    }
    var content: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 220), spacing: 16)], spacing: 16) {
            ForEach(livestreams) { livestream in
                LivestreamItem(livestream: livestream)
                    .frame(height: 220)
            }
        }
        .padding()
    }
}

struct LivestreamsView_Previews: PreviewProvider {
    static var previews: some View {
        LivestreamsView()
    }
}
