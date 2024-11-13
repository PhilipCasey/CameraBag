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
    @StateObject private var viewModel = GearItemViewModel(viewContext: PersistenceController.shared.container.viewContext)
    @State private var selectedGearItem: GearItem?
    @State private var isAddEditSheetPresented = false
    @State private var refreshID = UUID()

    var body: some View {
        NavigationStack {
            List {
                ForEach(["Cameras", "Lenses", "Flashes & Lights", "Accessories"], id: \.self) { category in
                    let categoryItems = viewModel.gearItems.filter { $0.category == category }

                    if !categoryItems.isEmpty {
                        Section(header: Text(category)) {
                            ForEach(categoryItems) { item in
                                NavigationLink(value: item) {
                                    VStack(alignment: .leading) {
                                        Text(item.brand ?? "Unknown")
                                            .font(.headline)
                                        Text(item.model ?? "Unknown")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .id(refreshID)  // Force a new view instance to reload UI
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
            .sheet(isPresented: $isAddEditSheetPresented, onDismiss: {
                refreshData()
            }) {
                AddEditGearView(gearItem: selectedGearItem)
            }
            .navigationDestination(for: GearItem.self) { item in
                GearDetailView(gearItem: item)
            }
            .onAppear {
                refreshData()  // Initial fetch when view appears
            }
        }
    }

    // Function to force refresh items and reset the view
    private func refreshData() {
        viewModel.fetchItems()  // Fetch latest data
        refreshID = UUID()  // Force view reload by changing the ID
    }
}
