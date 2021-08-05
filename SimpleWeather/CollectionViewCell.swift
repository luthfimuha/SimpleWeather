//
//  CollectionViewCell.swift
//  SimpleWeather
//
//  Created by Luthfi on 03/08/21.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet var bgImage: UIImageView!
    @IBOutlet var weatherImage: UIImageView!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var tempLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bgImage.layer.cornerRadius = 10
        bgImage.layer.masksToBounds = true
        
//        bgImage.layer.shadowColor = UIColor.black.cgColor
//        bgImage.layer.shadowOpacity = 1
//        bgImage.layer.shadowOffset = .zero
//        bgImage.layer.shadowRadius = 10
        // Initialization code
    }
    

}
