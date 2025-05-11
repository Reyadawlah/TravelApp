//
//  PackingListViewModel.swift
//  TravelApp
//
//  Created by Reya Dawlah on 1/15/25.
//

import CoreData


class PackingListViewModel: ObservableObject {
    @Published var packingItems: [PackingItem.DataModel] = []
    private let viewContext = PersistenceController.shared.container.viewContext
    
    func fetchItems() {
        let request = NSFetchRequest<PackingEntity>(entityName: "PackingEntity")
        
        do {
            let entities = try viewContext.fetch(request)
            packingItems = entities.map(PackingItem.DataModel.init)
        } catch {
            print("Error fetching packing items: \(error)")
        }
    }
    
    func addItem(name: String, category: String) {
        let newItem = PackingEntity(context: viewContext)
        newItem.id = UUID()
        newItem.name = name
        newItem.category = category
        newItem.isChecked = false
        
        save()
        fetchItems()
    }
    
    func deleteItem(id: UUID) {
        let request = NSFetchRequest<PackingEntity>(entityName: "PackingEntity")
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let entities = try viewContext.fetch(request)
            if let entityToDelete = entities.first {
                viewContext.delete(entityToDelete)
                save()
                fetchItems()
            }
        } catch {
            print("Error deleting packing item: \(error)")
        }
    }
    
    func updateItem(id: UUID, name: String, category: String, isChecked: Bool) {
        let request = NSFetchRequest<PackingEntity>(entityName: "PackingEntity")
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let entities = try viewContext.fetch(request)
            if let entityToUpdate = entities.first {
                entityToUpdate.name = name
                entityToUpdate.category = category
                entityToUpdate.isChecked = isChecked
                save()
                fetchItems()
            }
        } catch {
            print("Error updating packing item: \(error)")
        }
    }
    
    func toggleItemCheck(id: UUID) {
        let request = NSFetchRequest<PackingEntity>(entityName: "PackingEntity")
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let entities = try viewContext.fetch(request)
            if let entityToUpdate = entities.first {
                entityToUpdate.isChecked.toggle()
                save()
                fetchItems()
            }
        } catch {
            print("Error toggling item check: \(error)")
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
