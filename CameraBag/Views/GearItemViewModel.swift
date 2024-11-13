//
//  GearItemViewModel.swift
//  CameraBag
//
//  Created by Philip Casey on 11/12/24.
//
import Foundation
import CoreData
import Combine

class GearItemViewModel: ObservableObject {
    @Published var gearItems: [GearItem] = []
    private let viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        fetchItems()
    }

    func saveItem(_ item: GearItem) {
        do {
            try viewContext.save()
            fetchItems()
            print("Saved item: \(item)")
        } catch {
            print("Failed to save item: \(error)")
        }
    }

    func fetchItems() {
        let request: NSFetchRequest<GearItem> = GearItem.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \GearItem.brand, ascending: true)]

        do {
            gearItems = try viewContext.fetch(request)
            print("Fetched items: \(gearItems)")
        } catch {
            print("Failed to fetch gear items: \(error)")
        }
    }

    func addItem(brand: String, model: String, serialNumber: String, purchaseDate: Date, purchaseAmount: Double, category: String) {
        let newItem = GearItem(context: viewContext)
        newItem.id = UUID()
        newItem.brand = brand
        newItem.model = model
        newItem.serialNumber = serialNumber
        newItem.purchaseDate = purchaseDate
        newItem.purchaseAmount = purchaseAmount
        newItem.category = category

        saveItem(newItem)
    }

    func deleteItem(_ item: GearItem) {
        viewContext.delete(item)
        saveContext()
    }

    private func saveContext() {
        do {
            try viewContext.save()
            fetchItems()  // Refresh items after deleting
        } catch {
            print("Failed to save context after delete: \(error)")
        }
    }
}
