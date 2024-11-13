//
//  ContentView.swift
//  CameraBag
//
//  Created by Philip Casey on 11/12/24.
//
import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    // Fetches `GearItem` objects from Core Data
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \GearItem.brand, ascending: true)],
        animation: .default)
    private var gearItems: FetchedResults<GearItem>

    @State private var isAddEditSheetPresented = false
    @State private var selectedGearItem: GearItem?

    var body: some View {
        NavigationView {
            List {
                ForEach(gearItems) { item in
                    VStack(alignment: .leading) {
                        Text("Brand: \(item.brand ?? "Unknown")")
                        Text("Model: \(item.model ?? "Unknown")")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .onTapGesture {
                        selectedGearItem = item
                        isAddEditSheetPresented = true
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .navigationTitle("Camera Bag")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        selectedGearItem = nil
                        isAddEditSheetPresented = true
                    }) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $isAddEditSheetPresented) {
                AddEditGearView(gearItem: selectedGearItem)
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { gearItems[$0] }.forEach(viewContext.delete)
            saveContext()
        }
    }

    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
}
