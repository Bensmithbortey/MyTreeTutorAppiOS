//
//  Color.swift
//  MyTreeTutorApp (iOS)
//
//  Created by Benjamin-Smith Bortey on 20/03/2021.
//

import SwiftUI

enum MTTColor: String {
    case Primary,
         Secondary,
         TreeOutline,
         TreeBackground,
         TreeSelectedBackground
}

extension Color {
    
    init(_ mttColor: MTTColor) {
        self.init(mttColor.rawValue)
    }
    
}
