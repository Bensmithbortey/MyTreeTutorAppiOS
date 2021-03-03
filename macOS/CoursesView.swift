//
//  CoursesView.swift
//  MyTreeTutorApp (macOS)
//
//  Created by Benjamin-Smith Bortey on 03/03/2021.
//

import SwiftUI

struct CoursesView: View {
    @State var show = false
    
    var body: some View {
        ScrollView {
            content
            SectionTitle(title: "Recent sections")
            CourseContent()
        }
        .frame(minWidth: 500, idealWidth: 700, maxWidth: .infinity, minHeight: 300, maxHeight: .infinity)
        .navigationTitle("Courses")
    }
    var content: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 160), spacing: 16)], spacing: 12) {
            ForEach(courses) { course in
                CourseItem(course: course)
                    .frame(maxWidth: 200)
                    .sheet(isPresented: $show) {
                        CourseDetail()
                    }
                    .onTapGesture {
                        show.toggle()
                    }
            }
        }
        .padding()
    }
}

struct CoursesView_Previews: PreviewProvider {
    static var previews: some View {
        CoursesView()
    }
}

