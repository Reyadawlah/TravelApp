//
//  ContentView.swift
//  TravelApp
//
//  Created by Reya Dawlah on 1/11/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        // Replace NavigationView with NavigationStack
        NavigationStack {
            VStack(spacing: 20) {
                Text("Welcome to TripVault")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)

                NavigationLink(destination: ItineraryView()) {
                    Text("Manage Itinerary")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                NavigationLink(destination: BookingsView()) {
                    Text("Manage Bookings")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.teal)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                NavigationLink(destination: FlightsView()) {
                    Text("Add Flights")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                NavigationLink(destination: PackingListView()) {
                    Text("Packing List")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                NavigationLink(destination: VisaView()) {
                    Text("Visas")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
            .frame(maxWidth: 600)
            .navigationTitle("Home")
        }
    }
}

#Preview {
    ContentView()
}
