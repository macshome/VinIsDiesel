//
//  CarRow.swift
//  VinIsDiesel
//
//  Created by Josh Wisenbaker on 9/21/22.
//

import SwiftUI

struct CarRow: View {
    let car: Car
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                car.make.map(Text.init)
                    .font(.title)
                Spacer()
                if car.fuel == "Diesel" {
                    Image("vin-diesel-celebrity-mask")
                        .resizable()
                        .frame(width: 50, height: 50)
                    Spacer()
                }
                car.fuel.map(Text.init)
                    .font(.body)
                
            }
            
            HStack {
                car.model.map(Text.init)
                    .font(.caption)
                Spacer()
                car.year.map(Text.init)
                    .font(.caption)
            }
        }
    }
}
