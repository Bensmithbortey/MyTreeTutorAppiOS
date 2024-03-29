//
//  Images.swift
//  MyTreeTutorApp (iOS)
//
//  Created by Benjamin-Smith Bortey on 30.03.2021.
//

import SwiftUI

enum SystemImage: String {
    case backwardEnd = "backward.end",
         forwardEnd = "forward.end",
         pause = "pause",
         play = "play",
         arrowForward = "arrow.forward",
         arrowBackward = "arrow.backward",
         arrowUp = "arrow.up",
         arrowDown = "arrow.down",
         infoCircleFill = "info.circle.fill",
         star = "star",
         starFill = "star.fill"
}

extension Image {

    init(systemName: SystemImage) {
        self.init(systemName: systemName.rawValue)
    }

}
