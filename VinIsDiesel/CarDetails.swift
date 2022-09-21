//
//  SwiftUIView.swift
//  VinIsDiesel
//
//  Created by Josh Wisenbaker on 9/21/22.
//

import SwiftUI
import OSLog
import VINdicator

struct CarDetails: View {

    @State var year = ""
    @State var make = ""
    @State var model = ""
    @State var vin = ""
    @State var fuel = ""

    let onComplete: (String, String, String, String) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                TextField("VIN", text: $vin)
                    .onSubmit {
                        Task {
                            await vinLookup(vin)
                        }
                    }
                TextField("Year", text: $year)
                    .disabled(true)
                TextField("Make", text: $make)
                    .disabled(true)
                TextField("Model", text: $model)
                    .disabled(true)
                TextField("Fuel", text: $fuel)
                    .disabled(true)
                Section {
                    Button(action: addCarAction) {
                        Text("Add Car")
                    }
                }
            }
            .navigationTitle("Add a VIN")
        }
    }

    func vinLookup(_ vin: String) async {
        let client = VINdicator()
        do {
            let car = try await client.lookupVin(vin)
            year = car.year
            make = car.make
            model = car.model
            fuel = car.fuel
        } catch {
            Logger().log("Error: \(error.localizedDescription)")
        }
    }
    
    private func addCarAction() {
        onComplete(year, make, model, fuel)
    }
}
