//
//  Booking_CoreData.swift
//  TravelApp
//
//  Created by Reya Dawlah on 1/15/25.
//

import Foundation

struct Booking: Identifiable {
    let id = UUID()
    var name: String
    var hotelName: String
    var location: String
    var checkIn: String
    var checkOut: String
}
extension Booking {
    struct DataModel {
        let id: UUID
        let name: String
        let hotelName: String
        let location: String
        let checkinTime: String
        let checkoutTime: String
        
        init(entity: BookingEntity) {
            self.id = entity.id ?? UUID()
            self.name = entity.name ?? ""
            self.hotelName = entity.hotelName ?? ""
            self.location = entity.location ?? ""
            self.checkinTime = entity.checkinTime ?? ""
            self.checkoutTime = entity.checkoutTime ?? ""
        }
    }
}
