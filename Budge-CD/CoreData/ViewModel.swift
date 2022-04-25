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
    
    /// Save the current context to Core Data
    func save() {
        manager.save()
        getBudgets()
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
