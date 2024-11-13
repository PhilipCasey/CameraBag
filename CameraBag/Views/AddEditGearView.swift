//
//  AddEditGearView.swift
//  CameraBag
//
//  Created by Philip Casey on 11/12/24.
//
import SwiftUI

struct AddEditGearView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    var gearItem: GearItem?

    @State private var type = ""
    @State private var brand = ""
    @State private var model = ""
    @State private var serialNumber = ""
    @State private var purchaseDate = Date()
    @State private var purchaseAmount: Double = 0.0
    @State private var category = ""

    init(gearItem: GearItem? = nil) {
        self.gearItem = gearItem
        if let gearItem = gearItem {
            _type = State(initialValue: gearItem.type ?? "")
            _brand = State(initialValue: gearItem.brand ?? "")
            _model = State(initialValue: gearItem.model ?? "")
            _serialNumber = State(initialValue: gearItem.serialNumber ?? "")
            _purchaseDate = State(initialValue: gearItem.purchaseDate ?? Date())
            _purchaseAmount = State(initialValue: gearItem.purchaseAmount)
            _category = State(initialValue: gearItem.category ?? "")
        }
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Gear Details")) {
                    TextField("Type", text: $type)
                    TextField("Brand", text: $brand)
                    TextField("Model", text: $model)
                    TextField("Serial Number", text: $serialNumber)
                    DatePicker("Purchase Date", selection: $purchaseDate, displayedComponents: .date)
                    TextField("Purchase Amount", value: $purchaseAmount, format: .currency(code: "USD"))
                        .keyboardType(.decimalPad)
                    TextField("Category", text: $category)
                }
            }
            .navigationTitle(gearItem == nil ? "Add Gear" : "Edit Gear")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveGearItem()
                    }
                }
            }
        }
    }

    private func saveGearItem() {
        let item = gearItem ?? GearItem(context: viewContext)
        item.id = item.id ?? UUID()
        item.type = type
        item.brand = brand
        item.model = model
        item.serialNumber = serialNumber
        item.purchaseDate = purchaseDate
        item.purchaseAmount = purchaseAmount
        item.category = category

        do {
            try viewContext.save()
            dismiss()
        } catch {
            print("Failed to save gear item: \(error)")
        }
    }
}
