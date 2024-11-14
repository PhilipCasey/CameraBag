//
//  AddEditGearView.swift
//  CameraBag
//
//  Created by Philip Casey on 11/12/24.
//
import SwiftUI
import CoreData

struct AddEditGearView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    var gearItem: GearItem?

    @State private var brand = ""
    @State private var model = ""
    @State private var serialNumber = ""
    @State private var purchaseDate = Date()
    @State private var purchaseAmount: String = ""
    @State private var category = "Cameras" // Default value for category

    private let categories = ["Cameras", "Lenses", "Flashes & Lights", "Accessories"]

    init(gearItem: GearItem? = nil) {
        self.gearItem = gearItem
        if let gearItem = gearItem {
            _brand = State(initialValue: gearItem.brand ?? "")
            _model = State(initialValue: gearItem.model ?? "")
            _serialNumber = State(initialValue: gearItem.serialNumber ?? "")
            _purchaseDate = State(initialValue: gearItem.purchaseDate ?? Date())
            _purchaseAmount = State(initialValue: String(format: "%.2f", gearItem.purchaseAmount))
            _category = State(initialValue: gearItem.category ?? "Cameras") // Ensure the category is set correctly
        } else {
            _category = State(initialValue: "Cameras") // Default value for new items
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Gear Details")) {
                        HStack {
                            Text("Category:")
                                .fontWeight(.semibold)
                            Spacer()
                            Picker("", selection: $category) {
                                ForEach(categories, id: \.self) {
                                    Text($0)
                                }
                            }
                            .pickerStyle(.menu)
                            .labelsHidden()
                        }
                        HStack {
                            Text("Brand:")
                                .fontWeight(.semibold)
                            TextField("Enter brand", text: $brand)
                                .multilineTextAlignment(.trailing)
                        }
                        HStack {
                            Text("Model:")
                                .fontWeight(.semibold)
                            TextField("Enter model", text: $model)
                                .multilineTextAlignment(.trailing)
                        }
                        HStack {
                            Text("Serial Number:")
                                .fontWeight(.semibold)
                            TextField("Enter serial number", text: $serialNumber)
                                .multilineTextAlignment(.trailing)
                        }
                        HStack {
                            Text("Purchase Date:")
                                .fontWeight(.semibold)
                            DatePicker("", selection: $purchaseDate, displayedComponents: .date)
                                .datePickerStyle(.compact)
                                .labelsHidden()
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        HStack {
                            Text("Purchase Amount:")
                                .fontWeight(.semibold)
                            TextField("0.00", text: $purchaseAmount)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.trailing)
                                .onChange(of: purchaseAmount) {
                                    purchaseAmount = formatCurrencyInput(purchaseAmount)
                                }
                        }
                    }
                }

                Spacer()

                // Save Button at the Bottom, Centered
                Button(action: {
                    saveGearItem()
                }) {
                    Text("Save Item")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50) // Adjusted button size
                        .background(Color.blue)
                        .clipShape(Capsule()) // Pill-shaped button
                        .padding(.bottom, 20) // Space between the button and bottom
                }
            }
            .navigationTitle(gearItem == nil ? "Add Gear" : "Edit Gear")
            .toolbar {
                // Delete button at the top-right of the navigation bar
                if gearItem != nil {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Delete") {
                            deleteGearItem()
                        }
                        .foregroundColor(.red) // Delete button in red
                    }
                }
                // Cancel button at the top-left
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }

    private func formatCurrencyInput(_ input: String) -> String {
        let filtered = input.filter { "0123456789".contains($0) }
        let amount = (Double(filtered) ?? 0.0) / 100.0
        return String(format: "%.2f", amount)
    }

    private func saveGearItem() {
        let item = gearItem ?? GearItem(context: viewContext)
        item.id = item.id ?? UUID()
        item.brand = brand
        item.model = model
        item.serialNumber = serialNumber
        item.purchaseDate = purchaseDate
        item.purchaseAmount = Double(purchaseAmount) ?? 0.0
        item.category = category // Ensure category is saved correctly

        do {
            try viewContext.save()
            dismiss()
        } catch {
            print("Failed to save gear item: \(error)")
        }
    }

    private func deleteGearItem() {
        guard let gearItem = gearItem else { return }

        viewContext.delete(gearItem)
        do {
            try viewContext.save()
            dismiss() // Dismiss the view after deleting the item
        } catch {
            print("Failed to delete gear item: \(error)")
        }
    }
}
