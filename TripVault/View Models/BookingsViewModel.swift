//
//  BookingsViewModel.swift
//  TravelApp
//
//  Created by Reya Dawlah on 1/15/25.
//

import Foundation
import CoreData

class BookingsViewModel: ObservableObject {
    @Published var bookings: [Booking.DataModel] = []
    private let viewContext = PersistenceController.shared.container.viewContext
    
    func fetchBookings() {
        let request = NSFetchRequest<BookingEntity>(entityName: "BookingEntity")
        
        do {
            let entities = try viewContext.fetch(request)
            bookings = entities.map(Booking.DataModel.init)
        } catch {
            print("Error fetching bookings: \(error)")
        }
    }
    
    func addBooking(name: String, hotelName: String, location: String, checkinTime: String, checkoutTime: String) {
        let newBooking = BookingEntity(context: viewContext)
        newBooking.id = UUID()
        newBooking.name = name
        newBooking.hotelName = hotelName
        newBooking.location = location
        newBooking.checkinTime = checkinTime
        newBooking.checkoutTime = checkoutTime
        
        save()
        fetchBookings()
    }
    
    func deleteBooking(id: UUID) {
        let request = NSFetchRequest<BookingEntity>(entityName: "BookingEntity")
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let entities = try viewContext.fetch(request)
            if let entityToDelete = entities.first {
                viewContext.delete(entityToDelete)
                save()
                fetchBookings()
            }
        } catch {
            print("Error deleting booking: \(error)")
        }
    }
    
    func updateBooking(id: UUID, name: String, hotelName: String, location: String, checkinTime: String, checkoutTime: String) {
        let request = NSFetchRequest<BookingEntity>(entityName: "BookingEntity")
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let entities = try viewContext.fetch(request)
            if let entityToUpdate = entities.first {
                entityToUpdate.name = name
                entityToUpdate.hotelName = hotelName
                entityToUpdate.location = location
                entityToUpdate.checkinTime = checkinTime
                entityToUpdate.checkoutTime = checkoutTime
                save()
                fetchBookings()
            }
        } catch {
            print("Error updating booking: \(error)")
        }
    }
    
    private func save() {
        do {
            try viewContext.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}
