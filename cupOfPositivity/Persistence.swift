//
//  Persistence.swift
//  cupOfPositivity
//
//  Created by Vanessa Johnson on 2/17/24.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    static let preview = PersistenceController(inMemory: true)
    
    let container: NSPersistentContainer
    
    private init(container: NSPersistentContainer){
        self.container = container
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    private static func initializeContainer(inMemory: Bool) -> NSPersistentContainer {
    let container = NSPersistentContainer(name: "cupOfPositivity")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }
    
    private static func populateData(in container: NSPersistentContainer){
        let viewContext = container.viewContext
        let quoteArray = ["You are doing absolutely amazing", "You got this!", "You are so loved", "You will accomplish all your goals", "Take a self care day and get your nails done!", "You're hair is FIREEEE","Have you been working out?? DAMNNNNNN"]
        for i in 0..<quoteArray.count {
            let specificQuote = Quote(context: viewContext)
            specificQuote.quote = quoteArray[i]
            specificQuote.userAdded = false
            specificQuote.createdAt = Date()

        }

        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    init(inMemory: Bool = false){
        let container = Self.initializeContainer(inMemory: inMemory)
        Self.populateData(in: container)
        self.init(container: container)
    }
}
