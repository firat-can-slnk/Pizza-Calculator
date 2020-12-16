//
//  Sizes.swift
//  Pizza
//
//  Created by Firat Sülünkü on 15.12.20.
//

import Foundation
public enum Sizes: Int {
    case metric = 1
    case imperial = 2
    public func toString() -> String
    {
        switch self {
        case .imperial:
            return "in"
        case .metric:
            return "cm"
        }
    }
}
