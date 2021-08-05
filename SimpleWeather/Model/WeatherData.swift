//
//  WeatherData.swift
//  SimpleWeather
//
//  Created by Luthfi on 02/08/21.
//

import Foundation


struct WeatherData: Codable {
    let current: Current
    let hourly: [Hourly]
    let daily: [Daily]
}

struct Current: Codable {
    let temp: Double
    let wind_speed: Double
    let humidity: Double
    let weather: [Weather]
}

struct Weather: Codable {
    let main: String
    let id: Int
}

struct Hourly: Codable  {
    let dt: Double
    let temp: Double
    let weather: [Weather]
}

struct Daily: Codable {
    
    let dt: Double
    let temp: Temp
    let weather: [Weather]
    
}

struct Temp: Codable {
    let day: Double
    let night: Double
}
