//
//  GeocodeData.swift
//  SimpleWeather
//
//  Created by Luthfi on 03/08/21.
//

import Foundation

internal struct GeocodeData: Codable {
    let name: String
    let lat: Double
    let lon: Double
    let country: String
}
