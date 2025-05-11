//
//  VisaViewModel.swift
//  TravelApp
//
//  Created by Reya Dawlah on 1/23/25.
//

import CoreData
import PDFKit
import SwiftUI

class VisaViewModel: ObservableObject {
    @Published var visas: [Visa.DataModel] = []
    private let viewContext = PersistenceController.shared.container.viewContext
    
    func fetchVisas() {
        let request = NSFetchRequest<VisaEntity>(entityName: "VisaEntity")
        
        do {
            let entities = try viewContext.fetch(request)
            visas = entities.map(Visa.DataModel.init)
        } catch {
            print("Error fetching visas: \(error)")
        }
    }
    
    func addVisa(countryName: String, expirationDate: Date, pdfFileURL: URL?) {
        let newVisa = VisaEntity(context: viewContext)
        newVisa.id = UUID()
        newVisa.countryName = countryName
        newVisa.expirationDate = expirationDate
        newVisa.pdfFileURL = pdfFileURL?.absoluteString
        
        save()
        fetchVisas()
    }
    
    func deleteVisa(id: UUID) {
        let request = NSFetchRequest<VisaEntity>(entityName: "VisaEntity")
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let entities = try viewContext.fetch(request)
            if let entityToDelete = entities.first {
                // Optionally remove the PDF file if it exists
                if let urlString = entityToDelete.pdfFileURL,
                   let url = URL(string: urlString) {
                    try? FileManager.default.removeItem(at: url)
                }
                
                viewContext.delete(entityToDelete)
                save()
                fetchVisas()
            }
        } catch {
            print("Error deleting visa: \(error)")
        }
    }
    
    func updateVisa(id: UUID, countryName: String, expirationDate: Date, pdfFileURL: URL?) {
        let request = NSFetchRequest<VisaEntity>(entityName: "VisaEntity")
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let entities = try viewContext.fetch(request)
            if let entityToUpdate = entities.first {
                entityToUpdate.countryName = countryName
                entityToUpdate.expirationDate = expirationDate
                entityToUpdate.pdfFileURL = pdfFileURL?.absoluteString
                
                save()
                fetchVisas()
            }
        } catch {
            print("Error updating visa: \(error)")
        }
    }
    
    private func save() {
        do {
            try viewContext.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
    
    // Helper method to save PDF
    func savePDFToDocuments(pdfData: Data) -> URL? {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileName = "\(UUID().uuidString).pdf"
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        do {
            try pdfData.write(to: fileURL)
            return fileURL
        } catch {
            print("Error saving PDF: \(error)")
            return nil
        }
    }
}

// PDF Viewer
struct PDFViewer: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = PDFDocument(url: url)
        pdfView.autoScales = true
        return pdfView
    }
    
    func updateUIView(_ uiView: PDFView, context: Context) {}
}
