//
//  FlightsViewModel.swift
//  TravelApp
//
//  Created by Reya Dawlah on 1/15/25.
//

import Foundation
import CoreData

class FlightsViewModel: ObservableObject {
    @Published var flights: [Flight.DataModel] = []
    private let viewContext = PersistenceController.shared.container.viewContext
    
    func fetchFlights() {
        let request = NSFetchRequest<FlightEntity>(entityName: "FlightEntity")
        
        do {
            let entities = try viewContext.fetch(request)
            flights = entities.map(Flight.DataModel.init)
        } catch {
            print("Error fetching flights: \(error)")
        }
    }
    
    func addFlight(flightNumber: String, departureTime: String, gateInfo: String) {
        let newFlight = FlightEntity(context: viewContext)
        newFlight.id = UUID()
        newFlight.flightNumber = flightNumber
        newFlight.departureTime = departureTime
        newFlight.gateInfo = gateInfo
        
        save()
        fetchFlights()
    }
    
    func deleteFlight(id: UUID) {
        let request = NSFetchRequest<FlightEntity>(entityName: "FlightEntity")
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let entities = try viewContext.fetch(request)
            if let entityToDelete = entities.first {
                viewContext.delete(entityToDelete)
                save()
                fetchFlights()
            }
        } catch {
            print("Error deleting flight: \(error)")
        }
    }
    
    func updateFlight(id: UUID, flightNumber: String, departureTime: String, gateInfo: String) {
        let request = NSFetchRequest<FlightEntity>(entityName: "FlightEntity")
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let entities = try viewContext.fetch(request)
            if let entityToUpdate = entities.first {
                entityToUpdate.flightNumber = flightNumber
                entityToUpdate.departureTime = departureTime
                entityToUpdate.gateInfo = gateInfo
                save()
                fetchFlights()
            }
        } catch {
            print("Error updating flight: \(error)")
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
