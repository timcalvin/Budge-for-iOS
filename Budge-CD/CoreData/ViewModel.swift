//
//  ViewModel.swift
//  Budge-CD
//
//  Created by Timothy Bryant on 4/21/22.
//

import SwiftUI
import CoreData

class ViewModel: ObservableObject {
    
    let manager = CoreDataManager.instance
    
    @Published var budgets = [Budget]()
    
    /// Fetch all budgets and store in budgets property
    func getBudgets() {
        
        let request = NSFetchRequest<Budget>(entityName: "Budget")
        
        // TODO: - Add any sorthing or filtering
        
        do {
            budgets = try manager.context.fetch(request)
        } catch let error {
            print("TCB: Error fetching budgets: \(error.localizedDescription)")
        }
        
    }
    
    /// Add a new budget
    func addBudget(name: String, value: Double = 0, icon: String = "list.bullet", themeColor: String = "default") {
        let newBudget = Budget(context: manager.context)
        newBudget.name = name
        newBudget.value = value
        newBudget.icon = icon
        newBudget.themeColor = themeColor
        newBudget.timestamp = Date()
        save()
    }
    
    /// Update budget
    func updateBudget(budget: Budget, name: String, value: Double = 0, icon: String = "list.bullet", themeColor: String = "default") {
        let budget = budget
        budget.name = name
        budget.value = value
        budget.icon = icon
        budget.themeColor = themeColor
        save()
    }
    
    /// Delete budget
    func deleteBudget(budget: Budget) {
        manager.context.delete(budget)
        save()
    }
    
//    /// Get all items and store in items array of budgets property
//    func getItems() {
//
//    }
    
    /// Add new item
    func addItem(toBudget budget: Budget, withName name: String) {
        guard name.count > 0 else {
            print("Item name is too short")
            return
        }
        
        let newItem = Item(context: manager.context)
        newItem.budget = budget
        newItem.name = name
        newItem.quantity = 1.0
        newItem.value = 0
        newItem.isTaxable = false
        newItem.couponValue = 0
        newItem.isInCart = false
        newItem.timestamp = Date()
        save()
    }
    
    /// Update item
    func updateItem(_ item: Item, inBudget budget: Budget, name: String, quantity: Double, value: Double, isTaxable: Bool, couponValue: Double, isInCart: Bool, itemTotal: Double = 0) {
        
        let updateItem = item
        updateItem.name = name
        updateItem.budget = budget
        updateItem.quantity = quantity
        updateItem.value = value
        updateItem.isTaxable = isTaxable
        updateItem.couponValue = couponValue
        updateItem.isInCart = isInCart
        updateItem.itemTotal = itemTotal
        save()
    }
    
    /// Delete item
    func deleteItem(item: Item) {
        manager.context.delete(item)
        save()
    }
    
    /// Save the current context to Core Data
    func save() {
        manager.save()
        getBudgets()
    }
    
    func itemTotal(item: Item) -> Double {
        var itemTotal = (item.value * item.quantity) - item.couponValue
        if item.isTaxable {
            // FIXME: - Don't hard code tax rate once options are open
            let taxRate: Double = 6 / 100
            let tax = itemTotal * taxRate
            itemTotal += tax
            let roundedValue = round(itemTotal * 100) / 100.0
            itemTotal = roundedValue
        }
        return itemTotal
    }
    
    func updateBudgetValue(budget: Budget, newValue value: Double) {
        
        let updateBudget = budget
        updateBudget.value = value
        save()
        
    }
    
    func updateBudgetCartValue(budget: Budget, itemValue value: Double, addingToCart: Bool) {
        let updateBudget = budget
        var currentCartValue = budget.cartValue
        if addingToCart {
            currentCartValue += value
        } else {
            currentCartValue -= value
        }
        updateBudget.cartValue = currentCartValue
        save()
    }
    
    // TODO: - Do I need this or need to change it?
//    func getCartSubtotal(budget: Budget) -> Double {
//        var total = 0.0
//        for item in budget.itemsArray {
//            if item.isInCart {
//                total += item.itemTotal
//            }
//        }
//        return total
//    }
    
    // TODO: - Do I need this or need to change it?
//    func getCartTotal(budget: Budget, adjustment: Double, shouldAdjustUp: Bool) -> Double {
//        var total = getCartSubtotal(budget: budget)
//        if shouldAdjustUp {
//            total += adjustment
//        } else {
//            total -= adjustment
//        }
//        return total
//    }
    
    func getNumberOfItemsInCart(budget: Budget) -> Int {
        var total = 0
        for item in budget.itemsArray {
            if item.isInCart {
                total += 1
            }
        }
        return total
    }
    
    func emptyCart(fromBudget budget: Budget) {
        for item in budget.itemsArray {
            if item.isInCart {
                // TODO: - remove itemTotal from budget
                deleteItem(item: item)
            }
        }
        budget.value -= budget.cartValue
        budget.cartValue = 0
    }
    
    func iconColor(fromBudgetColor color: String) -> Color {
        if color == "default" {
            return .white
        } else if color == "red" {
            return .red
        } else if color == "orange" {
            return .orange
        } else if color == "yellow" {
            return .yellow
        } else if color == "green" {
            return .green
        } else if color == "purple" {
            return .purple
        } else {
            return .white
        }
    }
    
}
