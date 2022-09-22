//
//  SwiftUIView.swift
//  VinIsDiesel
//
//  Created by Josh Wisenbaker on 9/21/22.
//

import SwiftUI
import OSLog
import VINdicator
import CodeScanner

struct CarDetails: View {

    @State var year = ""
    @State var make = ""
    @State var model = ""
    @State var vin = ""
    @State var fuel = ""

    @State private var isShowingScanner = false

    let onComplete: (String, String, String, String) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                HStack {
                    TextField("VIN", text: $vin)
                        .onSubmit {
                            vinLookup(vin)
//                            Task {
//                            await vinLookup(vin)
//                            }
                        }
                    Button {
                        isShowingScanner = true
                    } label: {
                        Label("", systemImage: "camera")
                            .labelStyle(.iconOnly)
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
        .sheet(isPresented: $isShowingScanner) {
            CodeScannerView(codeTypes: [.code39],
                            simulatedData: "3FADP4BJ2FM195587",
                            completion: handleScan)
        }
    }

    private func vinLookup(_ vin: String) {
        let client = VINdicator()
            Task {
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
    }
    
    private func addCarAction() {
        onComplete(year, make, model, fuel)
    }

    private func handleScan(result: Result<ScanResult, ScanError>) {
        isShowingScanner = false
        switch result {
        case .success(let result):
            vin = result.string
            vinLookup(vin)
        case .failure(let error):
            Logger().log(level: .error, "Scanning failed: \(error.localizedDescription)")
        }
    }

    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            CarDetails(year: "1975", make: "Ford", model: "Grenade", vin: "", fuel: "Gasoline") { _,_,_,_ in }
        }
    }
}
