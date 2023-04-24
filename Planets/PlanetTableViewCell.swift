//
//  PlanetTableViewCell.swift
//  Planets
//
//  Created by Martin Doyle on 23/04/2023.
//

import UIKit

class PlanetTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var populationLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var moviesLabel: UILabel!
    
    static var reuseIdentifier: String {
        "PlanetCell"
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        moviesLabel.alpha = 0
        activityIndicator.startAnimating()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        moviesLabel.alpha = 0
        activityIndicator.startAnimating()
    }
    
}
