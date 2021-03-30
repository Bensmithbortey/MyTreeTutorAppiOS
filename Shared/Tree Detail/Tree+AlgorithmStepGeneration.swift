//
//  Tree+AlgorithmStepGeneration.swift
//  MyTreeTutorApp (iOS)
//
//  Created by Miroslav Kutak on 30.03.2021.
//

import Foundation

extension Tree where A == Unique<Int> {

    func generateSteps(algorithm: TreeAlgorithm) -> [AlgorithmStep] {

        var steps = [AlgorithmStep]()

        switch algorithm {
        case .preOrder:
            steps.append(AlgorithmStep(node: self))
            steps += left()?.generateSteps(algorithm: algorithm) ?? []
            steps += right()?.generateSteps(algorithm: algorithm) ?? []
        case .inOrder:
            steps += left()?.generateSteps(algorithm: algorithm) ?? []
            steps.append(AlgorithmStep(node: self))
            steps += right()?.generateSteps(algorithm: algorithm) ?? []
        case .postOrder:
            steps += left()?.generateSteps(algorithm: algorithm) ?? []
            steps += right()?.generateSteps(algorithm: algorithm) ?? []
            steps.append(AlgorithmStep(node: self))
        }

        return steps
    }

}
