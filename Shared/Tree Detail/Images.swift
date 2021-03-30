//
//  Images.swift
//  MyTreeTutorApp (iOS)
//
//  Created by Miroslav Kutak on 30.03.2021.
//

import SwiftUI

enum SystemImage: String {
    case backwardEnd = "backward.end",
         forwardEnd = "forward.end",
         pause = "pause",
         play = "play"
}

extension Image {

    init(systemName: SystemImage) {
        self.init(systemName: systemName.rawValue)
    }

}
