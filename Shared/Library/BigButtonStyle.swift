//
//  BigButtonStyle.swift
//  MyTreeTutorApp
//
//  Created by Miroslav Kutak on 08.04.2021.
//

import SwiftUI

struct BigButtonStyle: ButtonStyle {

    let foregroundColor: Color
    let backgroundColor: Color
    var padding: CGFloat = 20

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(padding)
            .frame(maxWidth: .infinity)
            .foregroundColor(foregroundColor)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct BigButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        Button(action: {}, label: {
            Text("Continue")
        })
        .buttonStyle(BigButtonStyle(foregroundColor: .white, backgroundColor: Color(.Primary)))
        .padding()
    }
}
