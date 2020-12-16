//
//  Pizza.swift
//  Pizza
//
//  Created by Firat Sülünkü on 15.12.20.
//

import Foundation

public class Pizza: Identifiable {
    var name: String
    var pizzeria: String?
    var type: PizzaType
    var diameter: Int?
    var firstSide: Int?
    var secondSize: Int?
    var price: Double
    var currency: Currency
    var sizes: Sizes
    
    init(name: String, pizzeria: String, firstSide: Int, secondSize: Int, price: Double, currency: Currency, sizes: Sizes) {
        self.name = name
        self.pizzeria = pizzeria
        self.type = PizzaType.rectangle
        self.firstSide = firstSide
        self.secondSize = secondSize
        self.price = price
        self.currency = currency
        self.sizes = sizes
    }
    init(name: String, pizzeria: String, diameter: Int, price: Double, currency: Currency, sizes: Sizes) {
        self.name = name
        self.pizzeria = pizzeria
        self.type = PizzaType.round
        self.diameter = diameter
        self.price = price
        self.currency = currency
        self.sizes = sizes
    }
    init(name: String, pizzeria: String, diameter: Int?, firstSide: Int?, secondSize: Int?, price: Double, currency: Currency, sizes: Sizes) {
        
        self.type = diameter == nil ? PizzaType.rectangle : PizzaType.round
        self.name = name
        self.pizzeria = pizzeria
        self.firstSide = firstSide
        self.secondSize = secondSize
        self.diameter = diameter
        self.price = price
        self.currency = currency
        self.sizes = sizes
    }
    public func factor() -> Double
    {
        switch type {
        case .round:
            return Pizza.factor(radius: self.diameter ?? 0,
                                price: self.price,
                                size: self.sizes)
        case .rectangle:
            return Pizza.factor(firstSide: self.firstSide ?? 0,
                                secondSize: self.secondSize ?? 0,
                                price: self.price,
                                size: self.sizes)
        }
        
    }
    
    public static func factor(radius: Int, price: Double, size: Sizes) -> Double
    {
        let pi:Double = 3.1415926535897
        var ret: Double = 0
        
        if size == .metric
        {
            ret = Double(radius) / 2
        }
        else
        {
            ret = Double(radius) * 2.54
            ret = ret / 2
        }
            
        ret = ret * ret
        ret = pi * ret
        ret = ret / (price == 0 ? 1 : price)
        
        ret = Double(String(format: "%.1f", ret)) ?? 0
        return ret
    }
    public static func factor(firstSide: Int, secondSize: Int, price: Double, size: Sizes) -> Double
    {
        var ret: Double = 0
        if size == .metric
        {
            ret = (Double(firstSide) * Double(secondSize)) / (price == 0 ? 1 : price)
        }
        else
        {
            ret = ((Double(firstSide) * 2.54) * (Double(secondSize)) * 2.54) / (price == 0 ? 1 : price)
        }
        
        ret = Double(String(format: "%.1f", ret)) ?? 0
        return ret
    }
    
    public func priceString() -> String
    {
        switch currency {
        case .EUR:
            return "\(String(format: "%.2f", self.price)) €"
        case .USD:
            return "$ \(String(format: "%.2f", self.price))"
        case .GBP:
            return "\(String(format: "%.2f", self.price)) £"
        }
    }
    public func sizeString() -> String
    {
        switch type {
        case .round:
            return "\(String(self.diameter!)) \(sizes.toString())"
        case .rectangle:
            return "\(String(self.firstSide!)) x \(String(self.secondSize!)) \(sizes.toString())"
        }
    }
    public static func TryParse(type: PizzaType, name: String?, pizzeria: String?, diameter: String?, firstSide: String?, secondSize: String?, price: String?, currency: Currency?, sizes: Sizes?) -> [PizzaErrors]
    {
        var ret: [PizzaErrors] = []
        
        if name == nil || name == "" {
            ret.append(.missingPizzaName)
        }
        
        if firstSide == nil || firstSide == "" && type == .rectangle {
            ret.append(.missingFirstSide)
        }
        else if (!(firstSide?.isInt() ?? true)) && type == .rectangle
        {
            ret.append(.wrongFirstSide)
        }
        
        if secondSize == nil || secondSize == "" && type == .rectangle {
            ret.append(.missingSecondSide)
        }
        else if (!(secondSize?.isInt() ?? true)) && type == .rectangle
        {
            ret.append(.wrongSecondSide)
        }
        
        if diameter == nil || diameter == "" && type == .round {
            ret.append(.missingDiameter)
        }
        else if (!(diameter?.isInt() ?? true)) && type == .round
        {
            ret.append(.wrongDiameter)
        }
        
        if price == nil || price == "" {
            ret.append(.missingPrice)
        }
        else if !(price?.isDouble() ?? true)
        {
            ret.append(.wrongPrice)
        }
        
        if currency == nil {
            ret.append(.missingCurrency)
        }
        
        if sizes == nil {
            ret.append(.missingSizes)
        }
        return ret
    }
    public static func GenerateAlertMessage(errors: [PizzaErrors]) -> String
    {
        var alertMessage: String = NSLocalizedString("Fehler beim hinzufügen der Pizza\n\n", comment: "Fehler beim hinzufügen der Pizza\n\n")
        
        if errors.contains(.missingPizzaName) {
            alertMessage.append(NSLocalizedString("Name der Pizza fehlt\n", comment: "Name der Pizza fehlt\n"))
        }
        if errors.contains(.missingFirstSide) {
            alertMessage.append(NSLocalizedString("Größe der ersten Seite fehlt\n", comment: "Größe der ersten Seite fehlt\n"))
        }
        if errors.contains(.wrongFirstSide) {
            alertMessage.append(NSLocalizedString("Größe der ersten Seite ist keine Zahl\n", comment: "Größe der ersten Seite ist keine Zahl\n"))
        }
        if errors.contains(.missingSecondSide) {
            alertMessage.append(NSLocalizedString("Größe der zweiten Seite fehlt\n", comment: "Größe der zweiten Seite fehlt\n"))
        }
        if errors.contains(.wrongSecondSide) {
            alertMessage.append(NSLocalizedString("Größe der zweiten Seite ist keine Zahl\n", comment: "Größe der zweiten Seite ist keine Zahl\n"))
        }
        if errors.contains(.missingDiameter) {
            alertMessage.append(NSLocalizedString("Durchmesser fehlt\n", comment: "Durchmesser fehlt\n"))
        }
        if errors.contains(.wrongDiameter) {
            alertMessage.append(NSLocalizedString("Durchmesser ist keine Zahl\n", comment: "Durchmesser ist keine Zahl\n"))
        }
        if errors.contains(.missingPrice) {
            alertMessage.append(NSLocalizedString("Preis fehlt\n", comment: "Preis fehlt\n"))
        }
        if errors.contains(.wrongPrice) {
            alertMessage.append(NSLocalizedString("Preis ist keine Zahl\n", comment: "Preis ist keine Zahl\n"))
        }
        if errors.contains(.missingCurrency) {
            alertMessage.append(NSLocalizedString("Währung fehlt\n", comment: "Währung fehlt\n"))
        }
        if errors.contains(.missingSizes) {
            alertMessage.append(NSLocalizedString("Größeneinheit fehlt\n", comment: "Größeneinheit fehlt\n"))
        }
        return alertMessage
    }
    
}
public enum PizzaErrors {
    case missingPizzaName
    case missingType
    case missingFirstSide
    case missingSecondSide
    case missingDiameter
    case missingPrice
    case missingCurrency
    case missingSizes
    case wrongPizzaName
    case wrongType
    case wrongFirstSide
    case wrongSecondSide
    case wrongDiameter
    case wrongPrice
    case wrongCurrency
    case wrongSizes
}
public enum PizzaType: Int
{
    case round = 1
    case rectangle = 2
}
