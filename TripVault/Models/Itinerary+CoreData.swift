//
//  Itinerary_CoreData.swift
//  TravelApp
//
//  Created by Reya Dawlah on 1/15/25.
//

import Foundation

struct ItineraryItem: Identifiable {
    let id = UUID()
    var name: String
    var details: String
}
extension ItineraryItem {
    struct DataModel {
        let id: UUID
        let name: String
        let details: String
        
        init(entity: ItineraryEntity) {
            self.id = entity.id ?? UUID()
            self.name = entity.name ?? ""
            self.details = entity.details ?? ""
        }
    }
}
