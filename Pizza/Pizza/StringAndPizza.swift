//
//  StringAndPizza.swift
//  Pizza
//
//  Created by Firat Sülünkü on 16.12.20.
//

import Foundation

/**
 Format:
 var name: String
 var pizzeria: String
 var type: PizzaType
 var diameter: Int?
 var firstSide: Int?
 var secondSize: Int?
 var price: Double
 var currency: Currency
 var sizes: Sizes
 
 every string is base64
 
 <name:Base64>,<pizzeria:Base64>,<type:int>,<diameter:int>,<firstSide:int>,<secondSize:int>,<price:double>,<currency:int>,<sizes:int>;
 */

public func PizzaToString(pizza: Pizza) -> String
{
    var ret:String = ""
    ret.append(pizza.name.base64Encoded ?? "")
    ret.append(",")
    ret.append(pizza.pizzeria?.base64Encoded ?? "")
    ret.append(",")
    
    switch pizza.type {
        case .round:
            ret.append("1")
            ret.append(",")
        case .rectangle:
            ret.append("2")
            ret.append(",")
    }
    ret.append(String(pizza.diameter ?? 0))
    ret.append(",")
    ret.append(String(pizza.firstSide ?? 0))
    ret.append(",")
    ret.append(String(pizza.secondSize ?? 0))
    ret.append(",")
    ret.append(String(pizza.price))
    ret.append(",")
    
    switch pizza.currency {
    case .EUR:
        ret.append("1")
        ret.append(",")
    case .USD:
        ret.append("2")
        ret.append(",")
    case .GBP:
        ret.append("3")
        ret.append(",")
        
    }
    switch pizza.sizes {
        case .metric:
                ret.append("1")
                ret.append(";")
        case .imperial:
                ret.append("2")
                ret.append(";")
    }
    return ret
}
public func StringToPizza(str: String) -> Pizza
{
    
    let splitted: [String] = str.components(separatedBy: ",")
    var ret: Pizza
    var currency: Currency = .EUR
    if Int(splitted[7]) == 1 {
        currency = .EUR
    }
    else if Int(splitted[7]) == 2 {
        currency = .USD
    }
    else if Int(splitted[7]) == 3 {
        currency = .GBP
    }
    if splitted[2] == "1"
    {
        ret = Pizza(name: splitted[0].base64Decoded!,
                               pizzeria: splitted[1].base64Decoded!,
                               diameter: Int(splitted[3])!,
                               price: Double(splitted[6])!,
                               currency: currency,
                               sizes: Int(splitted[8]) == 1 ? .metric : .imperial)
    }
    else
    {
        ret = Pizza(name: splitted[0].base64Decoded!,
                               pizzeria: splitted[1].base64Decoded!,
                               firstSide: Int(splitted[4])!,
                               secondSize: Int(splitted[5])!,
                               price: Double(splitted[6])!,
                               currency: currency,
                               sizes: Int(splitted[8]) == 1 ? .metric : .imperial)
    }
    
    
    
    return ret
return nil
}
public func PizzaArrayToString(pizza: [Pizza]) -> String
{
    var ret: String = ""
    for item in pizza {
        ret.append(PizzaToString(pizza: item))
    }
    if ret.count > 0 {
        ret.removeLast()
    }
    return ret
}
public func StringToPizzaArray(str: String) -> [Pizza]
{
    var string = str
    if str.last == ";"
    {
        string.removeLast()
    }
    
    let splitted: [String] = string.components(separatedBy: ";")
    var ret: [Pizza] = []
    if str == "" || splitted.count < 1 {
        return ret
    }
    for item in splitted {
        ret.append(StringToPizza(str: item))
    }
    return ret
}
