//
//  DailyCollectionViewCell.swift
//  Weather Application
//
//  Created by Safa Falaqi on 24/12/2021.
//

import UIKit

class DailyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var tempMinLabel: UILabel!
    @IBOutlet weak var tempMaxLabel: UILabel!
    
    @IBOutlet weak var image: UIImageView!
}
