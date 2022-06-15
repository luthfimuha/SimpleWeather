//
//  DailyCollectionViewCell.swift
//  SimpleWeather
//
//  Created by Luthfi on 04/08/21.
//

import UIKit

class DailyCollectionViewCell: UICollectionViewCell {

    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var descLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var weatherImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
