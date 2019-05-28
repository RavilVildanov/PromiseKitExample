//
//  Weather.swift
//  PromiseKitTest
//
//  Created by Равиль Вильданов on 29/04/2019.
//  Copyright © 2019 Vildanov. All rights reserved.
//

import Foundation

struct WeatherInfo: Codable {
    let main: Temperature
    let weather: [Weather]
    var name: String = "Error: invalid jsonDictionary! Verify your appID is correct"
}

struct Weather: Codable {
    let icon: String
    let description: String
}

struct Temperature: Codable {
    let temp: Double
}
