//
//  EquipmentRowView.swift
//  CameraBag
//
//  Created by Philip Casey on 10/6/24.
//

import SwiftUI

struct EquipmentRowView: View {
    var equipment: PhotoItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 3){
            Text(equipment.brand)
                .font(.headline)
            Text(equipment.name)
            HStack {
                //Text("#")
                //Text(equipment.serial)
            }
            .font(.subheadline)
        }
    }
}


#Preview {
    EquipmentRowView(equipment: PhotoItem(brand: "Sony", name: "a7r VI", serial: "234234"))
}
