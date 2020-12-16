//
//  ContentView.swift
//  Pizza
//
//  Created by Firat Sülünkü on 15.12.20.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @AppStorage("pizzas") var items: String = PizzaArrayToString(pizza: [
        Pizza(name: "Tonno", pizzeria: "Roma", diameter: 26, price: 12.65, currency: Currency.EUR, sizes: Sizes.metric),
        Pizza(name: "Marinara", pizzeria: "Romantica", diameter: 26, price: 6.90, currency: Currency.EUR, sizes: Sizes.metric),
        Pizza(name: "Margherita", pizzeria: "Venezia", diameter: 28, price: 8.90, currency: Currency.EUR, sizes: Sizes.metric),
        Pizza(name: "Diavolo", pizzeria: "Napoli", firstSide: 20, secondSize: 15, price: 19.90, currency: Currency.USD, sizes: Sizes.imperial),
        Pizza(name: "Funghi", pizzeria: "Pizza Express", firstSide: 50, secondSize: 35, price: 17.90, currency: Currency.GBP, sizes: Sizes.metric)
    ])
    
    @State var showAddPizza: Bool = false
    
    @State var itemsInList: [Pizza] = []
    
    init() {
        _itemsInList = State(wrappedValue: StringToPizzaArray(str: items))
    }

    var body: some View {
        NavigationView {
            if itemsInList.count > 0
            {
                List {
                    ForEach(itemsInList) { item in
                       
                        HStack {
                            VStack {
                                HStack
                                {
                                    Text(item.name).bold()
                                    if item.pizzeria != nil && item.pizzeria != "" {
                                        Divider()
                                        Text(String(item.pizzeria!)).fontWeight(.light)
                                    }
                                    Spacer()
                                    
                                }
                                HStack
                                {
                                    Text(item.sizeString())
                                    Divider()
                                    Text(item.priceString())
                                    Spacer()
                                }
                            }
                            Spacer()
                            Text(String(item.factor())).bold()
                        }
                        
                        
                    }
                    .onDelete(perform: delete)
                }
                .navigationBarItems(leading: EditButton(), trailing:  Button(action: {showAddPizza = true}, label: {
                    Text("Pizza hinzufügen")
                }))
                .navigationTitle("Pizzen")
                .listStyle(InsetGroupedListStyle())
                .sheet(isPresented: self.$showAddPizza) {
                    AddPizzaView(items: $itemsInList)
                }
            }
            else
            {
                Text("Die Liste ist leer\n\nBitte füge eine Pizza hinzu indem du oben rechts auf den Button drückst").fontWeight(.light).foregroundColor(.secondary).padding(60).multilineTextAlignment(.center)
                    .navigationBarItems(leading: EditButton(), trailing:  Button(action: {showAddPizza = true}, label: {
                        Text("Pizza hinzufügen")
                    }))
                    .navigationTitle("Pizzen")
                    .listStyle(InsetGroupedListStyle())
                    .sheet(isPresented: self.$showAddPizza) {
                        AddPizzaView(items: $itemsInList)
                    }
                    
            }
            
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    func UpdateStorage() {
        items = PizzaArrayToString(pizza: itemsInList)
    }
    func delete(at offsets: IndexSet) {
        itemsInList.remove(atOffsets: offsets)
        UpdateStorage()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
