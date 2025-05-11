//
//  Flights_CoreData.swift
//  TravelApp
//
//  Created by Reya Dawlah on 1/15/25.
//

import Foundation

struct Flight {
    let id: UUID
    var flightNumber: String
    var departureTime: String
    var gateInfo: String
}
extension Flight {
    struct DataModel {
        let id: UUID
        let flightNumber: String
        let departureTime: String
        let gateInfo: String
        
        init(entity: FlightEntity) {
            self.id = entity.id ?? UUID()
            self.flightNumber = entity.flightNumber ?? ""
            self.departureTime = entity.departureTime ?? ""
            self.gateInfo = entity.gateInfo ?? ""
        }
    }
}
