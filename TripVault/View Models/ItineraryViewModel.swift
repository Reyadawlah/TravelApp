//
//  ItineraryViewModel.swift
//  TravelApp
//
//  Created by Reya Dawlah on 1/15/25.
//

import CoreData

class ItineraryViewModel: ObservableObject {
    @Published var itineraryItems: [ItineraryItem.DataModel] = []
    private let viewContext = PersistenceController.shared.container.viewContext
    
    func fetchItems() {
        let request = NSFetchRequest<ItineraryEntity>(entityName: "ItineraryEntity")
        
        do {
            let entities = try viewContext.fetch(request)
            itineraryItems = entities.map(ItineraryItem.DataModel.init)
        } catch {
            print("Error fetching itinerary items: \(error)")
        }
    }
    
    func addItem(name: String, details: String) {
        let newItem = ItineraryEntity(context: viewContext)
        newItem.id = UUID()
        newItem.name = name
        newItem.details = details
        
        save()
        fetchItems()
    }
    
    func deleteItem(id: UUID) {
        let request = NSFetchRequest<ItineraryEntity>(entityName: "ItineraryEntity")
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let entities = try viewContext.fetch(request)
            if let entityToDelete = entities.first {
                viewContext.delete(entityToDelete)
                save()
                fetchItems()
            }
        } catch {
            print("Error deleting itinerary item: \(error)")
        }
    }
    
    func updateItem(id: UUID, name: String, details: String) {
        let request = NSFetchRequest<ItineraryEntity>(entityName: "ItineraryEntity")
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let entities = try viewContext.fetch(request)
            if let entityToUpdate = entities.first {
                entityToUpdate.name = name
                entityToUpdate.details = details
                save()
                fetchItems()
            }
        } catch {
            print("Error updating itinerary item: \(error)")
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
