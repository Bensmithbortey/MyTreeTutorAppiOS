//
//  Course.swift
//  MyTreeTutorApp
//
//  Created by Benjamin-Smith Bortey on 28/02/2021.
//

import SwiftUI

struct Course: Identifiable, Hashable {
    var id = UUID()
    var title: String
    var subtitle: String
    var color: Color
    var image: String
    var logo: String
    var show: Bool
    var index: Double
    var contentFileName: String
}

var courses = [
    Course(
        title: "Introduction to Trees",
        subtitle: "",
        color: Color(#colorLiteral(red: 0.3150139749, green: 0, blue: 0.8982304931, alpha: 1)),
        image: "Illustration 2",
        logo: "Logo SwiftUI",
        show: false,
        index: -1,
        contentFileName: "IntroductionToTrees"
    ),
    Course(
        title: "Binary Search Tree",
        subtitle: "",
        color: Color(#colorLiteral(red: 0, green: 0.5217629075, blue: 1, alpha: 1)),
        image: "Illustration 1",
        logo: "Logo UI Design",
        show: false,
        index: -1,
        contentFileName: "BinarySearchTree"
    ),
    Course(
        title: "Traversing Binary Tree",
        subtitle: "",
        color: Color(#colorLiteral(red: 0, green: 0.5217629075, blue: 1, alpha: 1)),
        image: "Illustration 1",
        logo: "Logo UI Design",
        show: false,
        index: -1,
        contentFileName: "TraversingBinary"
    ),
    Course(
        title: "Spanning Tree",
        subtitle: "",
        color: Color(#colorLiteral(red: 0.3150139749, green: 0, blue: 0.8982304931, alpha: 1)),
        image: "Illustration 2",
        logo: "Logo SwiftUI",
        show: false,
        index: -1,
        contentFileName: "SpanningTree"
    ),
    Course(
        title: "AVL Trees",
        subtitle: "",
        color: Color(#colorLiteral(red: 0, green: 0.7283110023, blue: 1, alpha: 1)),
        image: "Illustration 3",
        logo: "Logo UI Design",
        show: false,
        index: -1,
        contentFileName: "AVLTree"
    ),
    Course(
        title: "AVL Tree - Insertion",
        subtitle: "",
        color: Color(#colorLiteral(red: 0, green: 0.5217629075, blue: 1, alpha: 1)),
        image: "Illustration 1",
        logo: "Logo UI Design",
        show: false,
        index: -1,
        contentFileName: "AVLTreesInsertion"
    ),
    Course(
        title: "AVL Tree - Deletion",
        subtitle: "",
        color: Color(#colorLiteral(red: 0, green: 0.5217629075, blue: 1, alpha: 1)),
        image: "Illustration 1",
        logo: "Logo UI Design",
        show: false,
        index: -1,
        contentFileName: "AVLTreesDeletion"
    )
]
