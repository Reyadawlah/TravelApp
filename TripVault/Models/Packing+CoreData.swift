//
//  Packing_CoreData.swift
//  TravelApp
//
//  Created by Reya Dawlah on 1/15/25.
//

import Foundation

struct PackingItem: Identifiable {
    let id = UUID()
    var name: String
    var category: String
    var isChecked: Bool
}
extension PackingItem {
    struct DataModel {
        let id: UUID
        let name: String
        let category: String
        let isChecked: Bool
        
        init(entity: PackingEntity) {
            self.id = entity.id ?? UUID()
            self.name = entity.name ?? ""
            self.category = entity.category ?? ""
            self.isChecked = entity.isChecked
        }
    }
}
