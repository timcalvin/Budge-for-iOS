//
//  Item+CoreDataProperties.swift
//  Budge-CD
//
//  Created by Timothy Bryant on 4/25/22.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var couponValue: Double
    @NSManaged public var isInCart: Bool
    @NSManaged public var isTaxable: Bool
    @NSManaged public var itemTotal: Double
    @NSManaged public var name: String?
    @NSManaged public var quantity: Double
    @NSManaged public var timestamp: Date?
    @NSManaged public var cartTimestamp: Date?
    @NSManaged public var value: Double
    @NSManaged public var budget: Budget?
    
    public var unwrappedName: String {
        name ?? "No name"
    }
    
    public var unwrappedTimestamp: Date {
        timestamp ?? Date()
    }
    
    public var unwrappedCartTimestamp: Date {
        cartTimestamp ?? Date()
    }

}

extension Item : Identifiable {

}
