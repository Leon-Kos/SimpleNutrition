//
//  CustomTuple.swift
//  SimpleNutrition
//
//  Created by Leon Kos on 12.09.25.
//

import Foundation

class CustomTuple<S,T>: Identifiable {
    
    var id = UUID()
    
    var s: S
    var t: T
    
    init(s: S, t: T) {
        self.s = s
        self.t = t
    }

}
