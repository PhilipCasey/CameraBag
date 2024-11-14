//
//  GearItemViewModel.swift
//  CameraBag
//
//  Created by Philip Casey on 11/12/24.
//
import Foundation
import CoreData

class GearItemViewModel: ObservableObject {
    @Published var gearItems: [GearItem] = []
    private let viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        fetchItems()
    }

    func fetchItems() {
        let request: NSFetchRequest<GearItem> = GearItem.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \GearItem.brand, ascending: true)]

        do {
            gearItems = try viewContext.fetch(request)
        } catch {
            print("Failed to fetch gear items: \(error)")
        }
    }

    // Generate CSV data
    func generateCSV() -> String {
        var csvText = "Brand,Model,Serial Number,Purchase Date,Purchase Amount,Category\n"

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short

        for item in gearItems {
            let brand = item.brand ?? "Unknown"
            let model = item.model ?? "Unknown"
            let serialNumber = item.serialNumber ?? "N/A"
            let purchaseDate = item.purchaseDate != nil ? dateFormatter.string(from: item.purchaseDate!) : "N/A"
            let purchaseAmount = String(format: "%.2f", item.purchaseAmount)
            let category = item.category ?? "Unknown"

            let row = "\(brand),\(model),\(serialNumber),\(purchaseDate),\(purchaseAmount),\(category)\n"
            csvText.append(row)
        }

        return csvText
    }
}
