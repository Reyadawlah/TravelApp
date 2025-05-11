//
//  PackingListView.swift
//  TravelApp
//
//  Created by Reya Dawlah on 1/11/25.
//
import SwiftUI

struct PackingListView: View {
    @StateObject private var viewModel = PackingListViewModel()
    @State private var newItem: String = ""
    @State private var category: String = ""
    @State private var editingItem: PackingItem.DataModel? = nil
    @State private var selectedCategory: String? = nil

    var filteredItems: [PackingItem.DataModel] {
        if let selectedCategory = selectedCategory, !selectedCategory.isEmpty {
            return viewModel.packingItems.filter { $0.category == selectedCategory }
        }
        return viewModel.packingItems
    }

    var body: some View {
        VStack {
            Text("Packing List")
                .font(.title)
                .padding()

            VStack {
                TextField("Item Name", text: $newItem)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Category", text: $category)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button(action: {
                    if let editing = editingItem {
                        viewModel.updateItem(
                            id: editing.id,
                            name: newItem,
                            category: category,
                            isChecked: editing.isChecked
                        )
                        editingItem = nil
                    } else {
                        if !newItem.isEmpty {
                            viewModel.addItem(name: newItem, category: category)
                        }
                    }
                    newItem = ""
                    category = ""
                }) {
                    Text(editingItem == nil ? "Add" : "Save")
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding()

            Picker("Filter by Category", selection: $selectedCategory) {
                Text("All").tag(nil as String?)
                ForEach(Array(Set(viewModel.packingItems.map { $0.category })), id: \.self) { category in
                    Text(category).tag(category as String?)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()

            List {
                ForEach(filteredItems, id: \.id) { item in
                    HStack {
                        Button(action: {
                            viewModel.toggleItemCheck(id: item.id)
                        }) {
                            Image(systemName: item.isChecked ? "checkmark.square" : "square")
                                .foregroundColor(item.isChecked ? .green : .gray)
                        }

                        VStack(alignment: .leading) {
                            Text(item.name).font(.headline)
                            Text(item.category).font(.subheadline).foregroundColor(.gray)
                        }
                    }
                    .contextMenu {
                        Button("Edit") {
                            newItem = item.name
                            category = item.category
                            editingItem = item
                        }
                        Button("Delete", role: .destructive) {
                            viewModel.deleteItem(id: item.id)
                        }
                    }
                }
                .onDelete { indexSet in
                    indexSet.forEach { index in
                        let item = filteredItems[index]
                        viewModel.deleteItem(id: item.id)
                    }
                }
            }
        }
        .navigationTitle("Packing List")
        .frame(maxWidth: 600)
        .onAppear {
            viewModel.fetchItems()
        }
    }
}

#Preview {
    PackingListView()
}
