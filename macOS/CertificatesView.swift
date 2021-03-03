//
//  CertificatesView.swift
//  MyTreeTutorApp (macOS)
//
//  Created by Benjamin-Smith Bortey on 03/03/2021.
//

import SwiftUI

struct CertificatesView: View {
    var body: some View {
        ScrollView {
            content
        }
        .frame(minWidth: 500, idealWidth: 700, maxWidth: .infinity, minHeight: 500, maxHeight: .infinity)
        .navigationTitle("Certificates")
    }
    var content: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 220), spacing: 16)], spacing: 16) {
            ForEach(courses.indices) { index in
                FlipView(
                    item1: courses[index],
                    item2: courses[courses.count - index - 1],
                    color1: gradients[index].color1,
                    color2: gradients[index].color2
                )
            }
        }
        .padding()
    }
}

struct CertificatesView_Previews: PreviewProvider {
    static var previews: some View {
        CertificatesView()
    }
}
