//
//  PizzaApp.swift
//  Pizza
//
//  Created by Firat Sülünkü on 15.12.20.
//

import SwiftUI

@main
struct PizzaApp: App {
    let persistenceController = PersistenceController.shared
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .accentColor(.orange)
        }
    }
}
