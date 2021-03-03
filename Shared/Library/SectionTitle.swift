//
//  CloseeButton.swift
//  MyTreeTutorApp
//
//  Created by Benjamin-Smith Bortey on 28/02/2021.
//

import SwiftUI

struct SectionTitle: View {
    var title = "Recent"
    var body: some View {
        HStack {
            Text(title).bold()
                .padding(.horizontal)
                .padding(.top, 16)
            Spacer()
        }
    }
}

struct SectionTitle_Previews: PreviewProvider {
    static var previews: some View {
        SectionTitle()
    }
}
