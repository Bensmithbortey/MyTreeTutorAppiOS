//
//  BinaryTreeViewModel.swift
//  MyTreeTutorApp (iOS)
//
//  Created by Miroslav Kutak on 30.03.2021.
//

import SwiftUI
import Combine

class BinaryTreeViewModel: ObservableObject {
    var tree: Tree<Unique<Int>>?

    let objectWillChange = PassthroughSubject<Void, Never>()

    @Published var selectedAlgorithm: TreeAlgorithm?
    @Published var algorithmSteps = [AlgorithmStep]()
    @Published var selectedAlgorithmStep: AlgorithmStep?

    private var timer: Timer?
    private var algorithmStepIndex = 0

    init(tree: Tree<Unique<Int>>?) {
        self.tree = tree
    }

    func selectAlgorithm(_ selectedAlgorithm: TreeAlgorithm?) {
        self.selectedAlgorithm = selectedAlgorithm
        objectWillChange.send()
    }

    func generateSteps() {
        timer?.invalidate()

        guard let algorithm = selectedAlgorithm else { return }
        algorithmSteps = tree?.generateSteps(algorithm: algorithm) ?? []

        algorithmStepIndex = 0

        if !algorithmSteps.isEmpty {
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { _ in

                self.selectedAlgorithmStep = self.algorithmSteps[self.algorithmStepIndex]
                self.algorithmStepIndex += 1
                if self.algorithmStepIndex == self.algorithmSteps.count {
                    self.timer?.invalidate()
                }
                self.objectWillChange.send()
            })
        }
        objectWillChange.send()
    }

    func insert(_ value: Int) {
        if let tree = tree {
            tree.insert(value)
        } else {
            tree = Tree(Unique(value))
        }
        objectWillChange.send()
    }

    func generate(min: Int, max: Int, totalNodeCount: Int = 8) {
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
}
