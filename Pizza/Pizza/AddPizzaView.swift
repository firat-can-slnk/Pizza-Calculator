//
//  AddPizzaView.swift
//  Pizza
//
//  Created by Firat Sülünkü on 15.12.20.
//

import SwiftUI
import Combine

struct AddPizzaView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var pizzaName: String = ""
    @State var pizzeriaName: String = ""
    @State var type: Int = 1
    @State var currency: Int = 1
    @State var size: Int = 1
    @State var diameter: String = ""
    @State var firstSide: String = ""
    @State var secondSide: String = ""
    @State var price: String = ""
    @State var showAlert: Bool = false
    
    @Binding var items: [Pizza]
    @AppStorage("pizzas") var itemsStorage: String = PizzaArrayToString(pizza: [
        Pizza(name: "Tonno", pizzeria: "Roma", diameter: 32, price: 10, currency: Currency.EUR, sizes: Sizes.metric),
        Pizza(name: "Marinara", pizzeria: "Romantica", diameter: 26, price: 6.90, currency: Currency.EUR, sizes: Sizes.metric),
        Pizza(name: "Margherita", pizzeria: "Venezia", diameter: 28, price: 8.90, currency: Currency.EUR, sizes: Sizes.metric),
        Pizza(name: "Diavolo", pizzeria: "Napoli", firstSide: 60, secondSize: 40, price: 19.90, currency: Currency.USD, sizes: Sizes.imperial),
        Pizza(name: "Funghi", pizzeria: "Pizza Express", firstSide: 35, secondSize: 50, price: 17.90, currency: Currency.GBP, sizes: Sizes.metric)
    ])
    
    var body: some View {
        NavigationView {
        Form {
            Section(header: Text("Name"), content: {
                TextField("Name der Pizza", text: $pizzaName)
                TextField("Pizzeria", text: $pizzeriaName)
            })
            Section(header: Text("Maße"), content: {
                Picker(selection: $type, label: Text("Type")) {
                    Text("Rund").tag(1)
                    Text("Rechteckig").tag(2)
                }.pickerStyle(SegmentedPickerStyle())
                if type == 1
                {
                    HStack {
                        TextField("Durchmesser", text: $diameter).keyboardType(.numberPad)
                        .onReceive(Just(diameter)) { newValue in
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            if filtered != newValue {
                                self.diameter = filtered
                            }
                        }
                        Divider()
                        Picker(selection: $size, label: Text("")) {
                            Text(Sizes.init(rawValue: 1)!.toString()).tag(1)
                            Text(Sizes.init(rawValue: 2)!.toString()).tag(2)
                        }.pickerStyle(SegmentedPickerStyle())
                    }
                    
                }
                else
                {
                    HStack
                    {
                        VStack {
                            TextField("Erste Seite", text: $firstSide).keyboardType(.numberPad)
                            .onReceive(Just(firstSide)) { newValue in
                                let filtered = newValue.filter { "0123456789".contains($0) }
                                if filtered != newValue {
                                    self.firstSide = filtered
                                }
                            }.padding(.top, 5)
                            Divider().padding(.vertical, 5)
                            TextField("Zweite Seite", text: $secondSide).keyboardType(.numberPad)
                                .onReceive(Just(secondSide)) { newValue in
                                    let filtered = newValue.filter { "0123456789".contains($0) }
                                    if filtered != newValue {
                                        self.secondSide = filtered
                                    }
                                }.padding(.bottom, 5)
                        }
                        
                        Divider()
                        Picker(selection: $size, label: Text("")) {
                            Text(Sizes.init(rawValue: 1)!.toString()).tag(1)
                            Text(Sizes.init(rawValue: 2)!.toString()).tag(2)
                        }.pickerStyle(SegmentedPickerStyle())
                    }
                
                    
                    
                }
                
            })
            Section(header: Text("Kosten"), footer: Text("FactorDescription"), content: {
                HStack {
                    TextField("\(NSLocalizedString("Preis", comment: "Preis")) (format: 6.90)", text: $price)
                        .onReceive(Just(price)) { newValue in
                            let filtered = newValue.filter { "0123456789.".contains($0) }
                            if filtered != newValue {
                                self.price = filtered
                            }
                        }
                    Divider()
                    Picker(selection: $currency, label: Text("Currency")) {
                        Text(Currency.init(rawValue: 1)!.toString()).tag(1)
                        Text(Currency.init(rawValue: 2)!.toString()).tag(2)
                        Text(Currency.init(rawValue: 3)!.toString()).tag(3)
                    }.pickerStyle(SegmentedPickerStyle())
                }
                
                
                HStack {
                    Text("Faktor")
                    Spacer()
                    
                    if PizzaType.init(rawValue: type) == .round
                    {
                        let text = String(Pizza.factor(radius: Int(diameter == "" ? "0" : diameter) ?? 0, price: Double(price == "" ? "0" : price) ?? 0, size: Sizes.init(rawValue: size)!))
                        Text(text == "0.0" ? "n/a" : text)
                    }
                    else if PizzaType.init(rawValue: type) == .rectangle
                    {
                        let text = String(Pizza.factor(
                                        firstSide: Int(firstSide == "" ? "0" : firstSide) ?? 0,
                                          secondSize: Int(secondSide == "" ? "0" : secondSide) ?? 0,
                                            price: Double(price == "" ? "0" : price) ?? 0, size: Sizes.init(rawValue: size)!))
                        
                        Text(text == "0.0" ? "n/a" : text)
                    }
                   
                }
                
            })
        }
        .alert(isPresented: $showAlert) {
            return Alert(title: Text("Fehler"), message: Text(
                            Pizza.GenerateAlertMessage(
                                errors: Pizza.TryParse(type: PizzaType.init(rawValue: type)!,
                                               name: pizzaName,
                                               pizzeria: pizzeriaName,
                                               diameter: diameter,
                                               firstSide: firstSide,
                                               secondSize: secondSide,
                                               price: price,
                                               currency: Currency.init(rawValue: currency),
                                               sizes: Sizes.init(rawValue: size)
                                )
                            )
            ), dismissButton: Alert.Button.default(Text("Okay")))
        }
        .navigationBarItems(leading: Button(action: {
            presentationMode.wrappedValue.dismiss()
        }, label: {
            Text("Abbrechen").fontWeight(.medium).accentColor(.orange)
        }), trailing: Button(action: {
            if Pizza.TryParse(type: PizzaType.init(rawValue: type)!,
                              name: pizzaName,
                              pizzeria: pizzeriaName,
                              diameter: diameter,
                              firstSide: firstSide,
                              secondSize: secondSide,
                              price: price,
                              currency: Currency.init(rawValue: currency),
                              sizes: Sizes.init(rawValue: size)).count > 0
              {
                showAlert = true
              }
            else
            {
                items.append(Pizza(name: pizzaName,
                                                        pizzeria: pizzeriaName,
                                                        diameter: Int(diameter),
                                                        firstSide: Int(firstSide),
                                                        secondSize: Int(secondSide),
                                                        price: Double(price)!,
                                                        currency: Currency.init(rawValue: currency)!,
                                                        sizes: Sizes.init(rawValue: size)!))
                itemsStorage = PizzaArrayToString(pizza: items)
                presentationMode.wrappedValue.dismiss()
            }
            
        }) {
            Text("Fertig").bold().foregroundColor(.orange)
        })
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Pizza hinzufügen")
        
        
    }
    }
}

struct AddPizzaView_Previews: PreviewProvider {
    static var previews: some View {
        AddPizzaView(items: .constant([Pizza(name: "Tonno", pizzeria: "Roma", diameter: 32, price: 10, currency: Currency.EUR, sizes: Sizes.metric)]))
    }
}
