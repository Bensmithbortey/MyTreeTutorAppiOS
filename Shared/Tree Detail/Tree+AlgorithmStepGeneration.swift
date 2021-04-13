//
//  Tree+AlgorithmStepGeneration.swift
//  MyTreeTutorApp (iOS)
//
//  Created by Benjamin-Smith Bortey on 30.03.2021.
//

import Foundation

extension Tree where A == Unique<Int> {

    private func leftSteps(nodeID: UUID, algorithm: TreeAlgorithm) -> [AlgorithmStep] {
        var steps = [AlgorithmStep]()
        if let left = left() {
            steps.append(AlgorithmStep(nodeID: nodeID, node: self, direction: .leftDown))
            steps += left.generateSteps(algorithm: algorithm)
            steps.append(AlgorithmStep(nodeID: nodeID, node: self, direction: .leftUp))
        }
        return steps
    }

    private func rightSteps(nodeID: UUID, algorithm: TreeAlgorithm) -> [AlgorithmStep] {
        var steps = [AlgorithmStep]()
        if let right = right() {
            steps.append(AlgorithmStep(nodeID: nodeID, node: self, direction: .rightDown))
            steps += right.generateSteps(algorithm: algorithm)
            steps.append(AlgorithmStep(nodeID: nodeID, node: self, direction: .rightUp))
        }
        return steps
    }

    func generateSteps(algorithm: TreeAlgorithm) -> [AlgorithmStep] {

        var steps = [AlgorithmStep]()

        let nodeID = UUID()

        switch algorithm {
        case .preOrder:
            steps.append(AlgorithmStep(nodeID: nodeID, node: self, direction: .none))
            steps += leftSteps(nodeID: nodeID, algorithm: algorithm)
            steps += rightSteps(nodeID: nodeID, algorithm: algorithm)
        case .inOrder:
            steps += leftSteps(nodeID: nodeID, algorithm: algorithm)
            steps.append(AlgorithmStep(nodeID: nodeID, node: self, direction: .none))
            steps += rightSteps(nodeID: nodeID, algorithm: algorithm)
        case .postOrder:
            steps += leftSteps(nodeID: nodeID, algorithm: algorithm)
            steps += rightSteps(nodeID: nodeID, algorithm: algorithm)
            steps.append(AlgorithmStep(nodeID: nodeID, node: self, direction: .none))
        }

        return steps
    }

}
