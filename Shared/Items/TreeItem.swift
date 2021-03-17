//
//  TreeItem.swift
//  MyTreeTutorApp (iOS)
//
//  Created by Benjamin-Smith Bortey on 17/03/2021.
//

import SwiftUI

struct TreeItem: View {
    let treeType: TreeType
    
    #if os(iOS)
    var cornerRadius: CGFloat = 22
    #else
    var cornerRadius: CGFloat = 10
    #endif
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(treeType.image)
                    .renderingMode(.original)
                    .frame(width: 40, height: 40)
                    .padding(.all, 5)
                    .background(Color.white.opacity(0.1))
                    .clipShape(Circle())
                    .padding(.all, 1)
                Spacer()
            }
            Text(treeType.title)
                .bold()
                .foregroundColor(.white)
            Text(treeType.subtitle)
                .font(.footnote)
                .foregroundColor(Color.white.opacity(0.8))
        }
        .padding(16)
        .background(treeType.color)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .shadow(color: treeType.color.opacity(0.3), radius: 20, x: 0, y: 10)
    }
}

struct TreeItem_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            TreeItem(treeType: .binary)
                .frame(width: 400, height: 100)
        }
    }
}
