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
    
    init() {
        let currencyConverter = CurrencyConverter()
        
        currencyConverter.updateExchangeRates(completion: {
                    // The code inside here runs after all the data is fetched.
                    
                    // Now you can convert any currency:
                    // • Example_1 (USD to EUR):
            let doubleResult = currencyConverter.convert(10, valueCurrencyConverterCurrency: CurrencyConverterCurrency.USD, outputCurrencyConverterCurrency: CurrencyConverterCurrency.EUR)
                    print("••• 10 USD = \(doubleResult!) EUR •••")
                    
                    // • Example_2 (EUR to GBP) - Returning a formatted String:
            let formattedResult = currencyConverter.convertAndFormat(10, valueCurrencyConverterCurrency: CurrencyConverterCurrency.EUR, outputCurrencyConverterCurrency: CurrencyConverterCurrency.GBP, numberStyle: .decimal, decimalPlaces: 4)
                    print("••• Formatted Result (10 EUR to GBP): \(formattedResult!) •••")
                })
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .accentColor(.orange)
        }
    }
}
