//
//  Budget+CoreDataProperties.swift
//  Budge-CD
//
//  Created by Timothy Bryant on 4/25/22.
//
//

import Foundation
import CoreData


extension Budget {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Budget> {
        return NSFetchRequest<Budget>(entityName: "Budget")
    }

    @NSManaged public var icon: String?
    @NSManaged public var name: String?
    @NSManaged public var themeColor: String?
    @NSManaged public var timestamp: Date?
    @NSManaged public var value: Double
    @NSManaged public var items: NSSet?
    @NSManaged public var cartValue: Double
    
    public var unwrappedName: String {
        name ?? "No Name"
    }
    
    public var unwrappedIcon: String {
        icon ?? "list.bullet"
    }
    
    public var unwrappedThemeColor: String {
        themeColor ?? "default"
    }
    
    public var unwrappedTimestamp: Date {
        timestamp ?? Date()
    }
    
    public var itemsArray: [Item] {
        let array = items as? Set<Item> ?? []
        return array.sorted {
            $0.unwrappedName < $1.unwrappedName
        }
    }

}

// MARK: Generated accessors for items
extension Budget {

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: Item)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: Item)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSSet)

}

extension Budget : Identifiable {

}
