//
//  SwiftUIView.swift
//  VinIsDiesel
//
//  Created by Josh Wisenbaker on 9/21/22.
//

import SwiftUI
import OSLog
import VINdicator
import CoreData

struct CarDetails: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State var year = ""
    @State var make = ""
    @State var model = ""
    @State var vin = ""

    var body: some View {
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
        }
    }

    func vinLookup(_ vin: String) async {
        let client = VINdicator()
        do {
            let car = try await client.lookupVin(vin)
            year = car.year
            make = car.make
            model = car.model
            try viewContext.save()
        } catch {
            Logger().log("Error: \(error.localizedDescription)")
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        CarDetails(year: "2022", make: "Canine", model: "Dingo")

    }
}
