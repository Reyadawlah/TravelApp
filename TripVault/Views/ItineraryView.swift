//
//  ItineraryView.swift
//  TravelApp
//
//  Created by Reya Dawlah on 1/11/25.
//

import SwiftUI

struct ItineraryView: View {
    @StateObject private var viewModel = ItineraryViewModel()
    @State private var newItem: String = ""
    @State private var newDetails: String = ""
    @State private var editingItem: ItineraryItem.DataModel? = nil

    var body: some View {
        VStack {
            Text("Your Itinerary")
                .font(.title)
                .padding()

            VStack {
                TextField("Add or Edit Activity", text: $newItem)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Details", text: $newDetails)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button(action: {
                    if let editing = editingItem {
                        viewModel.updateItem(id: editing.id, name: newItem, details: newDetails)
                        editingItem = nil
                    } else {
                        if !newItem.isEmpty {
                            viewModel.addItem(name: newItem, details: newDetails)
                        }
                    }
                    newItem = ""
                    newDetails = ""
                }) {
                    Text(editingItem == nil ? "Add" : "Save")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding()

            List {
                ForEach(viewModel.itineraryItems, id: \.id) { item in
                    VStack(alignment: .leading) {
                        Text(item.name).font(.headline)
                        Text(item.details).font(.subheadline).foregroundColor(.gray)
                    }
                    .contextMenu {
                        Button("Edit") {
                            newItem = item.name
                            newDetails = item.details
                            editingItem = item
                        }
                        Button("Delete", role: .destructive) {
                            viewModel.deleteItem(id: item.id)
                        }
                    }
                }
                .onDelete { indexSet in
                    indexSet.forEach { index in
                        let item = viewModel.itineraryItems[index]
                        viewModel.deleteItem(id: item.id)
                    }
                }
            }
        }
        .navigationTitle("Itinerary")
        .frame(maxWidth: 600)
        .onAppear {
            viewModel.fetchItems()
        }
    }
}

#Preview {
    ItineraryView()
}
