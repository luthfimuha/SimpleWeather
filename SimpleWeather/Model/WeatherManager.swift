//
//  WeatherManager.swift
//  SimpleWeather
//
//  Created by Luthfi on 02/08/21.
//

import Foundation
import CoreLocation



protocol  WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didUpdateGeocode(_ weatherManager: WeatherManager, geocode: GeocodeModel)
    func didFailWithError(error: Error)
    func didFailWithError(error: String)
}


struct WeatherManager {
    
    var geocodeURL = "https://api.openweathermap.org/geo/1.0/direct?appid=7c14ae68ceac5fece02a4708e1242768"

    
    var forecastURL = "https://api.openweathermap.org/data/2.5/onecall?appid=7c14ae68ceac5fece02a4708e1242768&exclude=minutely&units=metric"
    
    var cityURL = "https://api.openweathermap.org/geo/1.0/reverse?appid=7c14ae68ceac5fece02a4708e1242768"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchCity(lat:Double, lon:Double) {
        let urlString = "\(cityURL)&lat=\(lat)&lon=\(lon)"
        performRequest(with: urlString, type: "geocode")
    }
    
    func fetchGeocode(cityName: String) {
        let urlString = "\(geocodeURL)&q=\(cityName)"
        let safeURL = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        if let url = safeURL {
            performRequest(with: url, type: "geocode")
        }
    }

    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        let urlString = "\(forecastURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString, type: "weather")
    }
    
    func performRequest(with urlString: String, type: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    
                    if type == "geocode" {
                        
                        if let geocode = self.parseGeocodeJSON(safeData) {
                            self.delegate?.didUpdateGeocode(self, geocode: geocode)
                        }
                        
                    } else {
                        if let weather = self.parseWeatherJSON(safeData) {
                            self.delegate?.didUpdateWeather(self, weather: weather)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseWeatherJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
      
            
            let id = decodedData.current.weather[0].id
            let desc = decodedData.current.weather[0].main
            let temp = decodedData.current.temp
            let humidity = decodedData.current.humidity
            let wind = decodedData.current.wind_speed
            
            
            let currentWeather = CurrentWeather(conditionId: id, temperature: temp, desc: desc, wind: wind, humidity: humidity)
            
            let hourly: [Hourly] = decodedData.hourly
            
            var hourlyForecast: [HourlyForecast] = []
            
            for i in 0...12 {
                hourlyForecast.append(HourlyForecast(time: hourly[i].dt, temp: hourly[i].temp, id: hourly[i].weather[0].id, desc: hourly[i].weather[0].main))
            }
            
            let daily: [Daily] = decodedData.daily
            
            var dailyForecast: [DailyForecast] = []
            
            for i in daily {
                dailyForecast.append(DailyForecast(time: i.dt, day_temp: i.temp.day, night_temp: i.temp.night, conditionID: i.weather[0].id, desc: i.weather[0].main))
            }
            
            
            let weather = WeatherModel(currentWeather: currentWeather, hourlyForecast: hourlyForecast, dailyForecast: dailyForecast)

            return weather
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    func parseGeocodeJSON(_ geocodeData: Data) -> GeocodeModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode([GeocodeData].self, from: geocodeData)
//            print(decodedData)
            
            if decodedData.isEmpty {
                delegate?.didFailWithError(error: "City Not Found")

                return nil
            }
            
            else {
                let name = decodedData.first!.name
                let lat = decodedData.first!.lat
                let lon = decodedData.first!.lon
                let country = decodedData.first!.country
                let geocode = GeocodeModel(name:name, lat: lat, lon: lon, country: country)
                
//                let geocode = GeocodeModel(name: "", lat: 0, lon: 0, country: "")
                return geocode
            }
            
            

        } catch {
            delegate?.didFailWithError(error: error)
            print("ERROR")
            return nil
        }
    }
    
    
}
