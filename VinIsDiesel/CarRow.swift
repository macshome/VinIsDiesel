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
                car.fuel.map(Text.init)
                
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
