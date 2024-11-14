//
//  GearDetailView.swift
//  CameraBag
//
//  Created by Philip Casey on 11/13/24.
//
import SwiftUI
import CoreData

struct GearDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    @ObservedObject var gearItem: GearItem

    @State private var isEditPresented = false

    var body: some View {
        Form {
            Section(header: Text("Details")) {
                HStack {
                    Text("Brand:")
                        .fontWeight(.semibold)
                    Spacer()
                    Text(gearItem.brand ?? "Unknown")
                }
                HStack {
                    Text("Model:")
                        .fontWeight(.semibold)
                    Spacer()
                    Text(gearItem.model ?? "Unknown")
                }
                HStack {
                    Text("Serial Number:")
                        .fontWeight(.semibold)
                    Spacer()
                    Text(gearItem.serialNumber ?? "N/A")
                }
                HStack {
                    Text("Purchase Date:")
                        .fontWeight(.semibold)
                    Spacer()
                    Text(gearItem.purchaseDate ?? Date(), formatter: DateFormatter.shortDate)
                }
                HStack {
                    Text("Purchase Amount:")
                        .fontWeight(.semibold)
                    Spacer()
                    Text(gearItem.purchaseAmount, format: .currency(code: "USD"))
                }
                HStack {
                    Text("Category:")
                        .fontWeight(.semibold)
                    Spacer()
                    Text(gearItem.category ?? "Unknown")
                }
            }
        }
        .navigationTitle(gearItem.model ?? "Gear")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit") {
                    isEditPresented = true
                }
            }
        }
        .sheet(isPresented: $isEditPresented) {
            AddEditGearView(gearItem: gearItem) // Pass gearItem to AddEditGearView
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
