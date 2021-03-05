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
}

var courses = [
    Course(
        title: "Introduction to Trees",
        subtitle: "",
        color: Color(#colorLiteral(red: 0.3150139749, green: 0, blue: 0.8982304931, alpha: 1)),
        image: "Illustration 2",
        logo: "Logo SwiftUI",
        show: false,
        index: -1
    ),
    Course(
        title: "Binary Search Tree",
        subtitle: "",
        color: Color(#colorLiteral(red: 0, green: 0.5217629075, blue: 1, alpha: 1)),
        image: "Illustration 1",
        logo: "Logo UI Design",
        show: false,
        index: -1
    ),
    Course(
        title: "Spanning Tree",
        subtitle: "",
        color: Color(#colorLiteral(red: 0.3150139749, green: 0, blue: 0.8982304931, alpha: 1)),
        image: "Illustration 2",
        logo: "Logo SwiftUI",
        show: false,
        index: -1
    ),
    Course(
        title: "AVL Trees",
        subtitle: "",
        color: Color(#colorLiteral(red: 0, green: 0.7283110023, blue: 1, alpha: 1)),
        image: "Illustration 3",
        logo: "Logo UI Design",
        show: false,
        index: -1
    )
//    Course(
//        title: "Design System in Figma",
//        subtitle: "12 sections",
//        color: Color(#colorLiteral(red: 1, green: 0.3477956653, blue: 0.3974102139, alpha: 1)),
//        image: "Illustration 6",
//        logo: "Logo Figma",
//        show: false,
//        index: -1
//    ),
//    Course(
//        title: "React for designers",
//        subtitle: "12 sections",
//        color: Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)),
//        image: "Illustration 7",
//        logo: "Logo React",
//        show: false,
//        index: -1
//    ),
//    Course(
//        title: "UI Design for developers",
//        subtitle: "20 sections",
//        color: Color(#colorLiteral(red: 0.1446507573, green: 0.8378821015, blue: 0.9349924922, alpha: 1)),
//        image: "Illustration 8",
//        logo: "Logo UI Design",
//        show: false,
//        index: -1
//    )
]
