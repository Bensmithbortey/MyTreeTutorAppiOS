//
//  MyTreeTutorApp.swift
//  Shared
//
//  Created by Benjamin-Smith Bortey on 27/02/2021.
//

import SwiftUI

@main
struct MyTreeTutorApp: App {
    let persistenceController = PersistenceController.shared

    init() {
        // Cache the HTML content so that we can display it faster
        for course in courses {
            HTMLTextCache.shared.generateAttributedString(for: course.contentFileName)
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
