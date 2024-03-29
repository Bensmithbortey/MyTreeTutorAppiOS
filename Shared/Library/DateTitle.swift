//
//  CloseeButton.swift
//  MyTreeTutorApp
//
//  Created by Benjamin-Smith Bortey on 03/03/2021.
//

import SwiftUI

struct DateTitle: View {
    var title = ""
    
    let taskDateFormat: DateFormatter =     {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }()
    var currentDate = Date()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            Text("\(currentDate, formatter: taskDateFormat)")
                .font(Font.subheadline.smallCaps()).bold()
                .foregroundColor(.secondary)
            
            HStack {
                Text(title)
                    .font(.largeTitle).bold()
                Spacer()
            }
        }
        .padding()
        .offset(x: 0, y: 20)
    }
}

struct DateTitle_Previews: PreviewProvider {
    static var previews: some View {
        DateTitle()
    }
}
