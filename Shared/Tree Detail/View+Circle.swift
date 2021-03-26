//
//  View+Circle.swift
//  
//
//  Created by Benjamin-Smith Bortey on 26/03/2021.
//

import SwiftUI


extension View {
    func roundedCircle() -> some View {
        self
            .frame(width: 50, height: 50)
            .background(Circle().stroke())
            .background(Circle().fill(Color(.TreeBackground)))
            .padding(10)
    }
    
    func roundedOutline() -> some View {
        self
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(lineWidth: 2)
                    .foregroundColor(.gray)
            )
    }
}

struct View_Circle_Previews: PreviewProvider {
    static var previews: some View {
        Text("hello")
            .roundedCircle()
    }
}
