//
//  GearItemViewModel.swift
//  CameraBag
//
//  Created by Philip Casey on 11/12/24.
//

import Foundation

class GearItemViewModel: ObservableObject {
    @Published var type = ""
    @Published var brand = ""
    @Published var model = ""
    @Published var serialNumber = ""
    @Published var purchaseDate = Date()
    @Published var purchaseAmount: Double = 0.0
    @Published var category = ""

    init(gearItem: GearItem? = nil) {
        if let gearItem = gearItem {
            self.type = gearItem.type ?? ""
            self.brand = gearItem.brand ?? ""
            self.model = gearItem.model ?? ""
            self.serialNumber = gearItem.serialNumber ?? ""
            self.purchaseDate = gearItem.purchaseDate ?? Date()
            self.purchaseAmount = gearItem.purchaseAmount
            self.category = gearItem.category ?? ""
        }
    }
}
