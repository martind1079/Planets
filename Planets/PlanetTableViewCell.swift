//
//  PlanetTableViewCell.swift
//  Planets
//
//  Created by Martin Doyle on 23/04/2023.
//

import UIKit

class PlanetTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    static var reuseIdentifier: String {
        "PlanetCell"
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
