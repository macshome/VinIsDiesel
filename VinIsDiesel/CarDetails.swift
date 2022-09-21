//
//  SwiftUIView.swift
//  VinIsDiesel
//
//  Created by Josh Wisenbaker on 9/21/22.
//

import SwiftUI


struct CarDetails: View {
    @State var year = ""
    @State var make = ""
    @State var model = ""
    @State var vin = ""

    var body: some View {
        Form {
            TextField("VIN", text: $vin)
            TextField("Year", text: $year)
            TextField("Make", text: $make)
            TextField("Model", text: $model)
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        CarDetails(year: "2022", make: "Canine", model: "Dingo")

    }
}
