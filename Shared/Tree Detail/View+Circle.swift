//
//  View+Circle.swift
//  
//
//  Created by Benjamin-Smith Bortey on 26/03/2021.
//

import SwiftUI


extension View {
    func roundedCircle() -> some View {
        let width: CGFloat = 40
        
        return self
            .frame(width: width, height: width)
            .background(Circle().stroke())
            .background(Circle().fill(Color(.TreeBackground)))
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

    func squaredOutline(color: Color = .blue) -> some View {
        self
            .background(color)
            .overlay(
                Rectangle()
                    .stroke()
                    .foregroundColor(.black)
            )
    }
}

struct View_Circle_Previews: PreviewProvider {
    static var previews: some View {
        Text("hello")
            .roundedCircle()
    }
}
