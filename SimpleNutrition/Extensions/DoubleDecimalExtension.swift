//
//  DoubleDecimalExtension.swift
//  SimpleNutrition
//
//  Created by Leon Kos on 29.03.26.
//

import Foundation

extension Double {
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
