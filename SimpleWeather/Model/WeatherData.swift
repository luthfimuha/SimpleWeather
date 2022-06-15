//
//  WeatherData.swift
//  SimpleWeather
//
//  Created by Luthfi on 02/08/21.
//

import Foundation


internal struct WeatherData: Codable {
    let current: Current
    let hourly: [Hourly]
    let daily: [Daily]
}

internal struct Current: Codable {
    let temp: Double
    let wind_speed: Double
    let humidity: Double
    let weather: [Weather]
}

internal struct Weather: Codable {
    let main: String
    let id: Int
}

internal struct Hourly: Codable  {
    let dt: Double
    let temp: Double
    let weather: [Weather]
}

internal struct Daily: Codable {
    let dt: Double
    let temp: Temp
    let weather: [Weather]
}

internal struct Temp: Codable {
    let day: Double
    let night: Double
}
