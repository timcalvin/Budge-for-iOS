//
//  CoreDataManager.swift
//  Budge-CD
//
//  Created by Timothy Bryant on 4/21/22.
//

import Foundation
import CoreData

class CoreDataManager {
    
    // Singleton
    static let instance = CoreDataManager()
    
    let container: NSPersistentContainer
    let context: NSManagedObjectContext
    
    init() {
        container = NSPersistentContainer(name: "BudgeModel")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("TCB: Error loading Core Data: \(error)")
            }
        }
        context = container.viewContext
    }
    
    func save() {
        do {
            try context.save()
            print("TCB: Saved successfully!")
        } catch let error {
            print("TCB: Error saving Core Data: \(error.localizedDescription)")
        }
    }
    
}
