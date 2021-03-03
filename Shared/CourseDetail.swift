//
//  CourseDetail.swift
//  MyTreeTutorApp
//
//  Created by Benjamin-Smith Bortey on 28/02/2021.
//

import SwiftUI

struct CourseDetail: View {
    var course: Course = courses[0]
    @Environment(\.presentationMode) var presentationMode
    
    @ViewBuilder
    var body: some View {
        #if os(iOS)
        content
        #else
        content.frame(maxWidth: 800, maxHeight: 600)
        #endif
    }
    
    var content: some View {
        ZStack(alignment: .topTrailing) {
            ScrollView {
                CourseItem(course: course, cornerRadius: 0)
                    .frame(maxHeight: 300)
                CourseContent()
            }
            
            CloseButton()
                .padding(20)
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }
        }
    }
}

struct CourseDetail_Previews: PreviewProvider {
    static var previews: some View {
        CourseDetail()
    }
}
