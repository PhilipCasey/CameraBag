//
//  GearDetailView.swift
//  CameraBag
//
//  Created by Philip Casey on 11/13/24.
//
import SwiftUI

struct GearDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    @ObservedObject var gearItem: GearItem

    @State private var isEditPresented = false

    var body: some View {
        Form {
            Section(header: Text("Details")) {
                Text("Brand: \(gearItem.brand ?? "Unknown")")
                Text("Model: \(gearItem.model ?? "Unknown")")
                Text("Serial Number: \(gearItem.serialNumber ?? "N/A")")
                Text("Purchase Date: \(gearItem.purchaseDate ?? Date(), formatter: DateFormatter.shortDate)")
                Text("Purchase Amount: \(gearItem.purchaseAmount, format: .currency(code: "USD"))")
                Text("Category: \(gearItem.category ?? "Unknown")")
            }
        }
        .navigationTitle("Gear Details")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit") {
                    isEditPresented = true
                }
            }
        }
        .sheet(isPresented: $isEditPresented, onDismiss: {
            refreshGearItem()
        }) {
            AddEditGearView(gearItem: gearItem)
        }
    }

    private func refreshGearItem() {
        do {
            try viewContext.save()
            viewContext.refresh(gearItem, mergeChanges: true)
        } catch {
            print("Failed to refresh gear item: \(error)")
        }
    }
}

extension DateFormatter {
    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
}
