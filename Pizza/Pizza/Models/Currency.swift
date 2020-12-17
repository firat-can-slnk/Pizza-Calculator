//
//  Currency.swift
//  Pizza
//
//  Created by Firat Sülünkü on 15.12.20.
//

import Foundation
public enum Currency: Int {
    case EUR = 1
    case USD = 2
    case GBP = 3
    public func toString() -> String
    {
        switch self {
        case .EUR:
            return "€"
        case .USD:
            return "$"
        case .GBP:
            return "£"
        }
    }
    public func toString(price: String) -> String
    {
        switch self {
        case .EUR:
            return "\(price) €"
        case .USD:
            return "$ \(price)"
        case .GBP:
            return "\(price) £"
        }
    }
    func toConverter() -> CurrencyConverterCurrency
    {
        switch self {
        case .EUR:
            return CurrencyConverterCurrency.EUR
        case .USD:
            return CurrencyConverterCurrency.USD
        case .GBP:
            return CurrencyConverterCurrency.GBP
        }
    }
}
