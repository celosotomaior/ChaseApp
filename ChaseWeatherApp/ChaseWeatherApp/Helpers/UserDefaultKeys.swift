//
//  UserDefaultKeys.swift
//  ChaseWeatherApp
//
//  Created by Marcelo Sotomaior on 03/09/2023.
//

import Foundation
import UIKit
import ObjectiveC

enum UserDefaultKeys {
    static let combineSwitcherKey = "combineSwitcherKey"
    static let hasLaunchedBefore = "hasLaunchedBefore"
    static let city = "cityName"
    static var firstRequestInSessionKey = "firstRequestInSession"
    static var firstRequestInSession = false
    static var combineSwitcherValue = true // Set the initial value here
}
