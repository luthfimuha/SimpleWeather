//
//  ViewController.swift
//  SimpleWeather
//
//  Created by Luthfi on 02/08/21.
//

//api key : 7c14ae68ceac5fece02a4708e1242768

import UIKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var iconImage: UIImageView!
    @IBOutlet var descLabel: UILabel!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var windLabel: UILabel!
    @IBOutlet var humidityLabel: UILabel!
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet var detailStackView: UIStackView!
    @IBOutlet var forecastView: UIView!
    @IBOutlet var errorLabel: UILabel!
    
    @IBOutlet var collectionView: UICollectionView!
    
    var weatherManager = WeatherManager()
    var weather: WeatherModel?
    var locationManager = CLLocationManager()
    @IBOutlet var contentView: UIStackView!
    
    let dataSource: [String] = ["USA", "Brazil", "China", "Japan", "Indo"]
    
    @IBOutlet var searchTextField: UITextField! {
        didSet {
            searchTextField.attributedPlaceholder = NSAttributedString(string: "Type a city..", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(white: 1, alpha: 0.7)])
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer( target: self, action: #selector(self.dismissKeyboard))
        
        
        tap.cancelsTouchesInView = true
        view.addGestureRecognizer(tap)
        
        
        
        weatherManager.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        searchTextField.delegate = self
        
        
        
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        let dateString = formatter.string(from: currentDateTime)
        dateLabel.text = "Today, \(dateString)"
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let nib = UINib(nibName: "CollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "myCell")
        
    }
    
    @objc func dismissKeyboard()
    {
        searchTextField.text = ""
        view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "forecastSegue" {
            let vc = segue.destination as? DailyViewController
            
            if let weather = weather {
                vc?.dailyForecast = weather.dailyForecast
            }
            if let location = cityLabel.text {
                vc?.location = location
            }
        }
    }
    
    
    func hideUI() {
        contentView.isHidden =  true
        self.errorLabel.isHidden = true
        self.loadingIndicator.startAnimating()
    }
    
    func showUI() {
        self.loadingIndicator.stopAnimating()
        
        contentView.isHidden = false
    }
    
    func showError(string: String) {
        self.loadingIndicator.stopAnimating()
        self.errorLabel.text = string
        self.errorLabel.isHidden = false
    }
    
    
    func getWeatherIcon(id: Int) -> String {
        
        switch id {
        case 200...232:
            return "thunderstorm"
        case 300...321:
            return "rain"
        case 500...531:
            return "rain"
        case 600...622:
            return "snow"
        case 701...781:
            return "mist"
        case 800:
            return "clear"
        case 801...804:
            return "cloudy"
        default:
            return "cloudy"
        }
        
    }
}

extension ViewController: WeatherManagerDelegate {
    
    func didFailWithError(error: String) {
        
        DispatchQueue.main.async {
            self.showError(string: error)
        }
        
    }
    
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            
            
            self.tempLabel.text = "\(weather.currentWeather.temperatureString)°"
//            self.iconImage.image = UIImage(named: weather.currentWeather.conditionName)
            self.iconImage.image = UIImage(named: self.getWeatherIcon(id: weather.currentWeather.conditionId))
//            self.cityLabel.text = "\(weather.cityName), \(weather.country)"
            self.descLabel.text = weather.currentWeather.desc
            self.windLabel.text = "\(weather.currentWeather.windString) m/s"
            self.humidityLabel.text = "\(weather.currentWeather.humidityString) %"
            
            self.weather = weather
            self.collectionView.reloadData()
            
            self.showUI()
         
            
        }
    }
    
    func didUpdateGeocode(_ weatherManager: WeatherManager, geocode: GeocodeModel) {
        DispatchQueue.main.async {
            self.cityLabel.text = "\(geocode.name), \(geocode.country)"
            weatherManager.fetchWeather(latitude: geocode.lat, longitude: geocode.lon)
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
}

extension ViewController: CLLocationManagerDelegate {
    
    @IBAction func locationPressed(_ sender: Any) {
        hideUI()
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchCity(lat: lat, lon: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}

extension ViewController: UITextFieldDelegate {
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(searchTextField.text!)
//        searchTextField.resignFirstResponder()
        searchTextField.endEditing(true)
        return true
    }
//
//    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//
//        if let city = searchTextField.text {
//            for character in city {
//                if !character.isWhitespace {
//                    return true
//                }
//              }
//              return false
//        } else {
//            return false
//        }
//    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        
        
        
        if let city = searchTextField.text {
            for character in city {
                if !character.isWhitespace {
                    self.hideUI()
                    weatherManager.fetchGeocode(cityName: city)
                    searchTextField.text = ""
                }
              }
        }
        
    }

}


extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let weather = weather {
            return (weather.hourlyForecast.count)
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! CollectionViewCell
        
        if let weather = weather {
//            cell.weatherImage.image = UIImage(named: (weather.hourlyForecast[indexPath.row].conditionName) )
            cell.weatherImage.image = UIImage(named: (self.getWeatherIcon(id: weather.hourlyForecast[indexPath.row].id)) )
            cell.tempLabel.text = "\(weather.hourlyForecast[indexPath.row].temperatureString)°"
            cell.timeLabel.text = weather.hourlyForecast[indexPath.row].timeString
        }
        
        
        return cell
        
        
    }


}

//extension UIViewController {
//    func dismissKey()
//    {
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer( target: self, action: #selector(UIViewController.dismissKeyboard))
//        tap.cancelsTouchesInView = false
//        view.addGestureRecognizer(tap)
//    }
//    @objc func dismissKeyboard()
//    {
//        view.endEditing(true)
//    }
//}

