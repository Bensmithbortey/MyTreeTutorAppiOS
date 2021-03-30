//
//  TreeAlgorithm.swift
//  MyTreeTutorApp (iOS)
//
//  Created by Miroslav Kutak on 30.03.2021.
//

import Foundation

enum TreeAlgorithm: String, Identifiable, CaseIterable {
    var id: String { rawValue }

    case inOrder = "In-Order",
         preOrder = "Pre-Order",
         postOrder = "Post-Order"
}
