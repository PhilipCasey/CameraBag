//
//  EquipmentRowViewDetail.swift
//  CameraBag
//
//  Created by Philip Casey on 10/6/24.
//

import SwiftUI

struct EquipmentRowViewDetail: View {
    var equipment: PhotoItem
    @State private var buttonText: String = "Serial"
    private let pasteboard = UIPasteboard.general
    
    func copyToClipboard() {
        pasteboard.string = self.equipment.serial
        self.buttonText = "Copied"
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.buttonText = "Serial"
        }
    }

    
    var body: some View {
        VStack(alignment: .center, spacing: 3){
            Spacer()
            VStack(alignment: .leading) {
                Text(equipment.brand)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                Text(equipment.name)
            }
                .font(.title2)
                .padding()
            HStack {
                Text("Serial Number:")
                Text(equipment.serial)
                    .textSelection(.enabled)
            }
            .font(.subheadline)
            Spacer()
            HStack(alignment: .center, spacing: 20) {

                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Text("Edit")
                })
                
                Button {
                    copyToClipboard()
                } label: {
                    Label(buttonText, systemImage: "doc.on.doc.fill")
                }
                
            }
        }
    }
}


#Preview {
    EquipmentRowViewDetail(equipment: PhotoItem(brand: "Sony", name: "a7r VI", serial: "234234"))
}
