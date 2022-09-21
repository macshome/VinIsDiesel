//
//  ContentView.swift
//  VinIsDiesel
//
//  Created by Josh Wisenbaker on 9/21/22.
//

import SwiftUI
import CoreData
import VINdicator
import OSLog

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Car.year, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Car>

    @State var year = ""
    @State var make = ""
    @State var model = ""
    @State var vin = ""
    
    var body: some View {
        NavigationView {
            List {
                ForEach(items) { item in
                    NavigationLink {
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
                    } label: {
                        if item.year == "" {
                            Text("\(item.year!) \(item.make!) \(item.model!)")
                        }

                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            Text("Select an item")
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Car(context: viewContext)
            newItem.uuid = UUID()
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func vinLookup(_ vin: String) async {
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

    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}
