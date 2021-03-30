//
//  AlgorithmStep.swift
//  MyTreeTutorApp (iOS)
//
//  Created by Miroslav Kutak on 30.03.2021.
//

import Foundation

struct AlgorithmStep: Identifiable {
    var id = UUID()
    let node: Tree<Unique<Int>>?
}
