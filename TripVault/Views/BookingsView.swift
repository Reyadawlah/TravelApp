//
//  AddHotelView.swift
//  TravelApp
//
//  Created by Reya Dawlah on 1/11/25.
//

import SwiftUI


struct BookingsView: View {
    @StateObject private var viewModel = BookingsViewModel()
    @State private var newBooking: String = ""
    @State private var hotelName: String = ""
    @State private var location: String = ""
    @State private var checkinTime: String = ""
    @State private var checkoutTime: String = ""
    @State private var editingBooking: Booking.DataModel? = nil
    
    var body: some View {
        VStack {
            Text("Your Bookings")
                .font(.title)
                .padding()
            
            VStack {
                TextField("Booking Name", text: $newBooking)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Hotel Name", text: $hotelName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Location", text: $location)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Check-In", text: $checkinTime)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Check-Out", text: $checkoutTime)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: {
                    if let editing = editingBooking {
                        viewModel.updateBooking(
                            id: editing.id,
                            name: newBooking,
                            hotelName: hotelName,
                            location: location,
                            checkinTime: checkinTime,
                            checkoutTime: checkoutTime
                        )
                        editingBooking = nil
                    } else {
                        if !newBooking.isEmpty {
                            viewModel.addBooking(
                                name: newBooking,
                                hotelName: hotelName,
                                location: location,
                                checkinTime: checkinTime,
                                checkoutTime: checkoutTime
                            )
                        }
                    }
                    newBooking = ""
                    hotelName = ""
                    location = ""
                    checkinTime = ""
                    checkoutTime = ""
                }) {
                    Text(editingBooking == nil ? "Add" : "Save")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding()
            
            List {
                ForEach(Array(viewModel.bookings.enumerated()), id: \.element.id) { index, booking in
                    VStack(alignment: .leading) {
                        Text(booking.name).font(.headline)
                        Text("Hotel: \(booking.hotelName)").font(.subheadline)
                        Text("Location: \(booking.location)").font(.subheadline)
                        Text("Check-In: \(booking.checkinTime) | Check-Out: \(booking.checkoutTime)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .contextMenu {
                        Button("Edit") {
                            newBooking = booking.name
                            hotelName = booking.hotelName
                            location = booking.location
                            checkinTime = booking.checkinTime
                            checkoutTime = booking.checkoutTime
                            editingBooking = booking
                        }
                        Button("Delete", role: .destructive) {
                            viewModel.deleteBooking(id: booking.id)
                        }
                    }
                }
                .onDelete { indexSet in
                    indexSet.forEach { index in
                        let booking = viewModel.bookings[index]
                        viewModel.deleteBooking(id: booking.id)
                    }
                }
            }
        }
        .navigationTitle("Bookings")
        .frame(maxWidth: 600)
        .onAppear {
            viewModel.fetchBookings()
        }
    }
}

#Preview {
    BookingsView()
}
