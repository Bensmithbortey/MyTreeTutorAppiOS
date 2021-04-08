//
//  BlurView.swift
//  MyTreeTutorApp
//
//  Created by Benjamin-Smith Bortey on 08.04.2021.
//

import SwiftUI

struct BlurView: View {
    var body: some View {
        #if os(iOS)
        return VisualEffectBlur(blurStyle: .systemMaterial)
        #else
        return VisualEffectBlur()
        #endif
    }
}

struct BlurView_Previews: PreviewProvider {
    static var previews: some View {
        BlurView()
    }
}
