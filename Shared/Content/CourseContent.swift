//
//  CourseContent.swift
//  MyTreeTutorApp
//
//  Created by Benjamin-Smith Bortey on 03/03/2021.
//

import SwiftUI

struct CourseContent: View {
    @State var show = false
    var body: some View {
        LazyVGrid(
            columns: [GridItem(.adaptive(minimum: 240), spacing: 16, alignment: .top)],
            spacing: 0) {
            ForEach(courseSections) { section in
                CourseRow(section: section)
                    .sheet(isPresented: $show) {
                        CourseSectionDetail(section: section)
                    }
                    .onTapGesture {
                        show.toggle()
                    }
            }
        }
        .padding(16)
    }
}

struct CourseContent_Previews: PreviewProvider {
    static var previews: some View {
        CourseContent()
    }
}

