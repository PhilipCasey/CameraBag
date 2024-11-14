//
//  ContentView.swift
//  CameraBag
//
//  Created by Philip Casey on 11/12/24.
//
import SwiftUI
import CoreData
import UIKit

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel = GearItemViewModel(viewContext: PersistenceController.shared.container.viewContext)
    @State private var selectedGearItem: GearItem?
    @State private var isAddEditSheetPresented = false
    @State private var refreshID = UUID()
    @State private var isShareSheetPresented = false
    @State private var csvURL: URL?

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
            .id(refreshID)
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
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        exportCSV()
                    }) {
                        Image(systemName: "square.and.arrow.up") // Share icon
                    }
                    .accessibilityLabel("Export CSV") // Accessibility label for the icon
                }
            }
            .sheet(isPresented: $isAddEditSheetPresented, onDismiss: {
                refreshData()
            }) {
                AddEditGearView(gearItem: selectedGearItem)
            }
            .sheet(isPresented: $isShareSheetPresented, content: {
                if let csvURL = csvURL, FileManager.default.fileExists(atPath: csvURL.path) {
                    ActivityView(activityItems: [csvURL])
                } else {
                    Text("CSV file could not be created.")
                        .padding()
                }
            })
            .navigationDestination(for: GearItem.self) { item in
                GearDetailView(gearItem: item)
            }
            .onAppear {
                refreshData() // Ensure data is fetched as soon as ContentView appears
            }
        }
    }

    private func exportCSV() {
        viewModel.fetchItems() // Ensure gear items are fetched before attempting to export

        if viewModel.gearItems.isEmpty {
            print("No items to export.")
            return
        }

        let csvText = viewModel.generateCSV()
        print("Generated CSV Text: \(csvText)")

        let fileManager = FileManager.default
        guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Failed to locate the Documents directory.")
            return
        }
        let fileURL = documentsURL.appendingPathComponent("GearItems.csv")

        // Remove any existing file at the destination path to avoid conflicts
        if fileManager.fileExists(atPath: fileURL.path) {
            do {
                try fileManager.removeItem(at: fileURL)
            } catch {
                print("Failed to remove existing CSV file: \(error)")
            }
        }

        do {
            try csvText.write(to: fileURL, atomically: true, encoding: .utf8)
            print("CSV file created at URL: \(fileURL)")
            if fileManager.fileExists(atPath: fileURL.path) {
                csvURL = fileURL
                // Introduce a slight delay to ensure everything is set before presenting the share sheet
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.isShareSheetPresented = true
                }
            } else {
                print("CSV file was not created successfully.")
            }
        } catch {
            print("Failed to write CSV file: \(error)")
        }
    }

    private func refreshData() {
        viewModel.fetchItems()
        refreshID = UUID()
    }
}

// ActivityView Struct
struct ActivityView: UIViewControllerRepresentable {
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: Context) -> UIActivityViewController {
        return UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
