//
//  GearItem+CoreDataProperties.swift
//  CameraBag
//
//  Created by Philip Casey on 11/12/24.
//
//

import Foundation
import CoreData


extension GearItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GearItem> {
        return NSFetchRequest<GearItem>(entityName: "GearItem")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var brand: String?
    @NSManaged public var model: String?
    @NSManaged public var serialNumber: String?
    @NSManaged public var purchaseDate: Date?
    @NSManaged public var purchaseAmount: Double
    @NSManaged public var category: String?

}

extension GearItem : Identifiable {

}
