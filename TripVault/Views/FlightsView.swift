//
//  AddFlightView.swift
//  TravelApp
//
//  Created by Reya Dawlah on 1/11/25.
//

import SwiftUI

struct FlightsView: View {
    @StateObject private var viewModel = FlightsViewModel()
    @State private var flightNumber: String = ""
    @State private var departureTime: String = ""
    @State private var gateInfo: String = ""
    @State private var editingFlight: Flight.DataModel? = nil
    
    var body: some View {
        VStack {
            Text("Your Flights")
                .font(.title)
                .padding()
            
            VStack {
                TextField("Flight Number", text: $flightNumber)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Departure Time", text: $departureTime)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Gate Information", text: $gateInfo)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: {
                    if let editing = editingFlight {
                        viewModel.updateFlight(
                            id: editing.id,
                            flightNumber: flightNumber,
                            departureTime: departureTime,
                            gateInfo: gateInfo
                        )
                        editingFlight = nil
                    } else {
                        if !flightNumber.isEmpty {
                            viewModel.addFlight(
                                flightNumber: flightNumber,
                                departureTime: departureTime,
                                gateInfo: gateInfo
                            )
                        }
                    }
                    flightNumber = ""
                    departureTime = ""
                    gateInfo = ""
                }) {
                    Text(editingFlight == nil ? "Add" : "Save")
                        .padding()
                        .background(Color.purple)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding()
            
            List {
                ForEach(viewModel.flights, id: \.id) { flight in
                    VStack(alignment: .leading) {
                        Text("Flight: \(flight.flightNumber)").font(.headline)
                        Text("Departure: \(flight.departureTime)").font(.subheadline)
                        Text("Gate: \(flight.gateInfo)").font(.subheadline).foregroundColor(.gray)
                    }
                    .contextMenu {
                        Button("Edit") {
                            flightNumber = flight.flightNumber
                            departureTime = flight.departureTime
                            gateInfo = flight.gateInfo
                            editingFlight = flight
                        }
                        Button("Delete", role: .destructive) {
                            viewModel.deleteFlight(id: flight.id)
                        }
                    }
                }
            }
        }
        .navigationTitle("Flights")
        .frame(maxWidth: 600)
        .onAppear {
            viewModel.fetchFlights()
        }
    }
}


#Preview {
    FlightsView()
}
