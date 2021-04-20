//
//  BinaryTreeViewModel.swift
//  MyTreeTutorApp (iOS)
//
//  Created by Benjamin-Smith Bortey on 30.03.2021.
//

import SwiftUI
import Combine

class BinaryTreeViewModel: ObservableObject {
    var tree: Tree<Unique<Int>>?

    let objectWillChange = PassthroughSubject<Void, Never>()

    var selectedAlgorithm: TreeAlgorithm?
    var algorithmSteps = [AlgorithmStep]()
    var arraySteps: [AlgorithmStep] {
        let dropLast = algorithmSteps.count - algorithmStepIndex - 1
        if dropLast >= 0 {
            return algorithmSteps.dropLast(dropLast).filter { $0.direction == .none }
        } else {
            return []
        }
    }
    var selectedAlgorithmStep: AlgorithmStep?
    var name: String?

    var speed: Float?
    var timeInterval: TimeInterval {
        return TimeInterval((10 - (speed ?? 5)) / 5)
    }

    public private(set) var algorithmStepIndex = 0

    var isPlayingAlgorithm: Bool = false

    init(tree: Tree<Unique<Int>>?) {
        self.tree = tree
    }

    func selectAlgorithm(_ selectedAlgorithm: TreeAlgorithm?) {
        self.selectedAlgorithm = selectedAlgorithm
        objectWillChange.send()
    }

    func generateSteps() {
        guard let algorithm = selectedAlgorithm else { return }
        AlgorithmStep.resetStepCounter()
        algorithmSteps = tree?.generateSteps(algorithm: algorithm) ?? []

        algorithmStepIndex = 0

        if !algorithmSteps.isEmpty {
            resume()
        }
        objectWillChange.send()
    }

    func pause() {
        isPlayingAlgorithm = false
        objectWillChange.send()
    }

    func resume() {
        guard !algorithmSteps.isEmpty else { return }

        isPlayingAlgorithm = true

        scheduleStep()
    }

    private func scheduleStep() {
        DispatchQueue.main.asyncAfter(deadline: .now() + timeInterval) {
            guard
                !self.algorithmSteps.isEmpty,
                self.algorithmSteps.count > self.algorithmStepIndex,
                self.isPlayingAlgorithm else {

                self.scheduleDeselect()
                return
            }

            self.selectedAlgorithmStep = self.algorithmSteps[self.algorithmStepIndex]
            if self.algorithmStepIndex == self.algorithmSteps.count - 1 {
                self.scheduleDeselect()
            } else {
                self.algorithmStepIndex += 1
                self.scheduleStep()
            }
            self.objectWillChange.send()
        }
    }

    private func scheduleDeselect() {
        DispatchQueue.main.asyncAfter(deadline: .now() + timeInterval) {
            self.selectedAlgorithmStep = nil
            self.isPlayingAlgorithm = false
            self.objectWillChange.send()
        }
    }

    func stepForward() {
        guard algorithmSteps.count - 1 > algorithmStepIndex else { return }

        algorithmStepIndex += 1
        selectedAlgorithmStep = algorithmSteps[algorithmStepIndex]
        pause()
    }

    func stepBackward() {
        guard algorithmStepIndex > 0 else { return }
        algorithmStepIndex -= 1
        selectedAlgorithmStep = algorithmSteps[algorithmStepIndex]
        pause()
    }

    func insert(_ value: Int) {
        if let tree = tree {
            tree.insert(value)
        } else {
            tree = Tree(Unique(value))
        }
        objectWillChange.send()
    }

    func generate(min: Int,
                  max: Int,
                  totalNodeCount: Int = 8) {
        let value = min + Int(arc4random() % UInt32(max - min))
        tree = Tree(Unique(value))

        // Insert 9 random elements, thus generating the random tree
        for _ in 0..<totalNodeCount {
            let value = min + Int(arc4random() % UInt32(max - min))
            tree?.insert(value)
        }
        objectWillChange.send()
    }

    func delete(_ selectedNodeID: UUID) {
        if let tree = tree, tree.value.id == selectedNodeID {
            self.tree = nil
        } else {
            tree?.delete(selectedNodeID)
        }
        objectWillChange.send()
    }

    func clear() {
        tree = nil
        name = ""
        algorithmStepIndex = 0
        isPlayingAlgorithm = false
        algorithmSteps.removeAll()
        objectWillChange.send()
    }
}
