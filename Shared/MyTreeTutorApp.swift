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

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
