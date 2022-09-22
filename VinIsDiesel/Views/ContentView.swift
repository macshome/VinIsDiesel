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
        sortDescriptors: [NSSortDescriptor(keyPath: \Car.timestamp, ascending: true)],
        animation: .default)
    
    private var items: FetchedResults<Car>

    @State var isPresented = false

    @AppStorage("needsAppOnboarding") private var needsAppOnboarding: Bool = true
    
    var body: some View {
        NavigationView {
            List {
                ForEach(items, id: \.make) {
                    CarRow(car: $0)
                }
                .onDelete(perform: deleteItems)
            }
            .sheet(isPresented: $isPresented) {
                CarDetails { year, make, model, fuel in
                    self.addItem(year: year, model: model, make: make, fuel: fuel)
                    self.isPresented = false
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: { self.isPresented.toggle() }) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            .navigationTitle("VIN is Diesel?")
        }
        .sheet(isPresented: $needsAppOnboarding) {
            OnboardingView()
        }
        
    }
    
    private func addItem(year: String, model: String, make: String, fuel: String) {
        withAnimation {
            let newItem = Car(context: viewContext)
            newItem.timestamp = Date()
            newItem.year = year
            newItem.model = model
            newItem.make = make
            newItem.fuel = fuel
            
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
    
    
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}
