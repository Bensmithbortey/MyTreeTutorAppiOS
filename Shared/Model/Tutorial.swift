//
//  Tutorial.swift
//  MyTreeTutorApp
//
//  Created by Benjamin-Smith Bortey on 03/03/2021.
//

import SwiftUI

struct Tutorial: Identifiable {
    var id = UUID()
    var title: String
    var subtitle: String
    var color: Color
    var image: String
    var progress: CGFloat
}

var tutorials = [
    Tutorial(
        title: "Binary Search Tree",
        subtitle: "SwiftUI is hands-down the best way for designers to take a first step into code. Thanks to its live Preview, you can iterate quickly and create powerful user interfaces with a few lines of code that works for all of Apple's platforms. Take your static design to the next level and build real apps with the simplicity of a prototyping tool.",
        color: Color(#colorLiteral(red: 0.2235294118, green: 0.07450980392, blue: 0.7215686275, alpha: 1)),
        image: "Logo SwiftUI",
        progress: 85.0
    ),
    Tutorial(
        title: "AVL Tree",
        subtitle: "Only a few years ago, Figma came out as the first design tool that utilized the power and accessibility of the Web while promising the same powerful features you’d expect from a native app. They surprised everyone with their real-time collaboration. Designers were ecstatic to finally be able to share their designs to their coworkers and clients with zero friction, and see multiple mouse pointers drawing shapes simultaneously. It was like magic.",
        color: Color(#colorLiteral(red: 1, green: 0.3529411765, blue: 0.4274509804, alpha: 1)),
        image: "Logo Figma",
        progress: 10.0
    ),
    Tutorial(
        title: "Rooted Trees",
        subtitle: "Many design courses focus on the finer details, heavy theories, getting you to the 99% of being a visual designer, but often disregard the code and handoff aspect. They end up alienating developers who just wish to learn the essentials. If you're looking to learn just enough UI design to be 100% self-sufficient and collaborate better with designers, this course if for you.",
        color: Color(#colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)),
        image: "Logo UI Design",
        progress: 30.0
    )
]
