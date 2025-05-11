//
//  VisaViewModel.swift
//  TravelApp
//
//  Created by Reya Dawlah on 1/23/25.
//

import Foundation
import CoreData

// Data Model
struct Visa: Identifiable {
    let id: UUID
    var countryName: String
    var expirationDate: Date
    var pdfFileURL: URL?
}

extension Visa {
    struct DataModel {
        let id: UUID
        let countryName: String
        let expirationDate: Date
        let pdfFileURL: URL?
        
        init(entity: VisaEntity) {
            self.id = entity.id ?? UUID()
            self.countryName = entity.countryName ?? ""
            self.expirationDate = entity.expirationDate ?? Date()
            self.pdfFileURL =  entity.pdfFileURL.flatMap { URL(string: $0) }
        }
    }
}
