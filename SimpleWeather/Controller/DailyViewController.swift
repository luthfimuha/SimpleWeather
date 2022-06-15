//
//  DailyViewController.swift
//  SimpleWeather
//
//  Created by Luthfi on 04/08/21.
//

import UIKit

class DailyViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    let dataSource: [String] = ["Monday", "Tuesday", "Wednesday", "Thursday"]
    
    @IBOutlet var cityLabel: UILabel!
    var dailyForecast: [DailyForecast] = []
    var location: String?
    
    @IBOutlet var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let nib = UINib(nibName: "DailyCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "dailyCell")
        
        if let location = location {
            cityLabel.text = location
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dailyForecast.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dailyCell", for: indexPath) as! DailyCollectionViewCell
        
        cell.dayLabel.text = dailyForecast[indexPath.row].day
        cell.dateLabel.text = dailyForecast[indexPath.row].date
        cell.tempLabel.text = dailyForecast[indexPath.row].tempString
        cell.weatherImage.image = UIImage(named: dailyForecast[indexPath.row].imageName)
        cell.descLabel.text = dailyForecast[indexPath.row].desc
        
        return cell
        
    }
}
