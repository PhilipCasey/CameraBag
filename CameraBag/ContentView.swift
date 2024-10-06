//
//  ContentView.swift
//  CameraBag
//
//  Created by Philip Casey on 10/6/24.
//

import SwiftUI

struct PhotoItem: Identifiable {
    var id = UUID()
    var brand: String
    var name: String
    var serial: String
}

struct EquipmentItem: Identifiable {
    var id = UUID()
    var groupName: String
    var items: [PhotoItem]
}

struct ContentView: View {
    
   @State var equipmentGroups = [
        EquipmentItem(groupName: "Cameras", items: [
            PhotoItem(brand: "Sony", name: "a7r VI", serial: "3322624"),
            PhotoItem(brand: "Fujifilm", name: "GFX 100s", serial: "230949508"),
            PhotoItem(brand: "Rolleiflex", name: "2.8F", serial: "2342323")
        ]),
        EquipmentItem(groupName: "Lenses", items: [
            PhotoItem(brand: "Sony Zeiss", name: "50mm f/1.4", serial: "234726"),
            PhotoItem(brand: "Sony", name: "35mm f/1.4 G Master", serial: "784938"),
            PhotoItem(brand: "Sony", name: "70-200mm f/2.8 OSS G Master", serial: "7693750"),
            PhotoItem(brand: "Sony", name: "16-35mm f/4",serial: "12332"),
            PhotoItem(brand: "Canon", name: "85mm f/1.2 L",serial: "7598370")
        ]),
        EquipmentItem(groupName: "Flashes", items: [
            PhotoItem(brand: "Profoto", name: "A10 for Sony", serial: "66555"),
            PhotoItem(brand: "Profoto", name: "A10 for Canon", serial: "33423")
        ])
    ]
    var body: some View {
        VStack {
            Text("Camera Bag")
                .font(.headline)
            NavigationView {
                List {
                    ForEach(equipmentGroups) { equipmentGroups in
                        Section(header: Text(equipmentGroups.groupName)) {
                            ForEach(equipmentGroups.items) { item in
                                NavigationLink(destination: EquipmentRowViewDetail(equipment: item)){
                                    EquipmentRowView(equipment: item)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}



#Preview {
    ContentView()
}
