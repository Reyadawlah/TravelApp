//
//  VisaView.swift
//  TravelApp
//
//  Created by Reya Dawlah on 1/23/25.
//

import SwiftUI
import PDFKit

struct VisaView: View {
    @StateObject private var viewModel = VisaViewModel()
    @State private var countryName: String = ""
    @State private var expirationDate = Date()
    @State private var editingVisa: Visa.DataModel? = nil
    @State private var showingDocumentPicker = false
    @State private var showingPDFViewer = false
    @State private var selectedPDFURL: URL?
    
    var body: some View {
        VStack {
            Text("Your Visas")
                .font(.title)
                .padding()
            
            VStack {
                TextField("Country Name", text: $countryName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                DatePicker("Expiration Date", selection: $expirationDate, displayedComponents: .date)
                    .datePickerStyle(CompactDatePickerStyle())
                
                Button("Select PDF") {
                    showingDocumentPicker = true
                }
                .padding()
                .background(Color.cyan)
                .foregroundColor(.white)
                .cornerRadius(8)
                
                Button(action: {
                    if let editing = editingVisa {
                        viewModel.updateVisa(
                            id: editing.id,
                            countryName: countryName,
                            expirationDate: expirationDate,
                            pdfFileURL: selectedPDFURL ?? editing.pdfFileURL
                        )
                        editingVisa = nil
                    } else {
                        if !countryName.isEmpty {
                            viewModel.addVisa(
                                countryName: countryName,
                                expirationDate: expirationDate,
                                pdfFileURL: selectedPDFURL
                            )
                        }
                    }
                    countryName = ""
                    expirationDate = Date()
                    selectedPDFURL = nil
                }) {
                    Text(editingVisa == nil ? "Add" : "Save")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding()
            
            List {
                ForEach(viewModel.visas, id: \.id) { visa in
                    VStack(alignment: .leading) {
                        Text("Country: \(visa.countryName)").font(.headline)
                        Text("Expires: \(visa.expirationDate, style: .date)").font(.subheadline)
                        if visa.pdfFileURL != nil {
                            Button("View PDF") {
                                selectedPDFURL = visa.pdfFileURL
                                showingPDFViewer = true
                            }
                            .foregroundColor(.blue)
                        }
                    }
                    .contextMenu {
                        Button("Edit") {
                            countryName = visa.countryName
                            expirationDate = visa.expirationDate
                            selectedPDFURL = visa.pdfFileURL
                            editingVisa = visa
                        }
                        Button("Delete", role: .destructive) {
                            viewModel.deleteVisa(id: visa.id)
                        }
                    }
                }
            }
        }
        .navigationTitle("Visas")
        .frame(maxWidth: 600)
        .onAppear {
            viewModel.fetchVisas()
        }
        .sheet(isPresented: $showingDocumentPicker) {
            DocumentPicker(fileURL: $selectedPDFURL)
        }
        .sheet(isPresented: $showingPDFViewer) {
            if let url = selectedPDFURL {
                PDFViewer(url: url)
            }
        }
    }
}

// Document Picker
struct DocumentPicker: UIViewControllerRepresentable {
    @Binding var fileURL: URL?
    @Environment(\.presentationMode) var presentationMode
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf], asCopy: true)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: DocumentPicker
        
        init(_ parent: DocumentPicker) {
            self.parent = parent
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else { return }
            parent.fileURL = url
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

#Preview {
    VisaView()
}
