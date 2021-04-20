//
//  Persistence.swift
//  Shared
//
//  Created by Benjamin-Smith Bortey on 27/02/2021.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let newItem = TreeModel(context: viewContext)
//            newItem.timestamp = Date()
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "MyTreeTutorApp")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                Typical reasons for an error here include:
                * The parent directory does not exist, cannot be created, or disallows writing.
                * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                * The device is out of space.
                * The store could not be migrated to the current model version.
                Check the error message to determine what the actual problem was.
                */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}

extension TreeModel {
    
    var sortedChildren: [TreeModel]{
        return children?.sorted(by: { (a, b) -> Bool in
            guard let a = a as? TreeModel, let b = b as? TreeModel else { return false }
            return a.value < b.value
        }) as! [TreeModel]
    }

    func generateTree() -> Tree<Unique<Int>> {
        
        let tree = Tree(Unique(Int(value)))
        
        for child in sortedChildren {
            tree.children.append(child.generateTree())
        }
        
        return tree
    }
    
}


extension Tree where A == Unique<Int> {
    
    func insertToCoreData(moc: NSManagedObjectContext) -> TreeModel {
        let treeModel = TreeModel(entity: TreeModel.entity(), insertInto: moc)
        treeModel.value = Int32(value.value)
        for child in children {
            let model = child.insertToCoreData(moc: moc)
            treeModel.addToChildren(model)
        }
        return treeModel
    }
    
    func insertToCoreData(moc: NSManagedObjectContext, title: String) throws {
        let request: NSFetchRequest<TreeModel> = TreeModel.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", title)
        if let existingModel = try moc.fetch(request).first {
            moc.delete(existingModel)
        }
        
        let treeModel = insertToCoreData(moc: moc)
        treeModel.title = title
        treeModel.isFavorite = false
        
        try moc.save()
    }
    
}
