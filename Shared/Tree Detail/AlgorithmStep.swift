//
//  AlgorithmStep.swift
//  MyTreeTutorApp (iOS)
//
//  Created by Benjamin-Smith Bortey on 30.03.2021.
//

import Foundation

enum AlgorithmStepDirection: CustomStringConvertible {
    case leftDown, rightDown, leftUp, rightUp, none

    var isLeft: Bool {
        return self == .leftDown || self == .leftUp
    }

    var isRight: Bool {
        return self == .rightDown || self == .rightUp
    }

    var description: String {
        switch self {
        case .leftDown:
            return "↙"
        case .leftUp:
            return "↗"// Coming from the left tree up
        case .rightDown:
            return "↘"
        case .rightUp:
            return "↖"// Coming from the right tree up
        case .none:
            return ""//"↔"
        }
    }
}

struct AlgorithmStep: Identifiable {
    let id = AlgorithmStep.getStepID()
    let nodeID: UUID
    let node: Tree<Unique<Int>>?
    let direction: AlgorithmStepDirection

    static public private(set) var stepCounter = 0
    static func getStepID() -> Int {
        stepCounter += 1
        return stepCounter
    }

    static func resetStepCounter() {
        stepCounter = 0
    }
}
