//
//  CustomExceptions.swift
//  SimpleNutrition
//
//  Created by Leon Kos on 02.04.26.
//

enum AddCustomViewExceptions: Error {
    case emptyProductName
    case emptyQuantity
    case emptyNutriscoreGrade
    case emptyCalories
    case emptyCarbohydrates
    case emptySugar
    case emptyProtein
    case emptyFat
    case emptySaturatedFat
    case emptyFiber
    case emptySalt
}
