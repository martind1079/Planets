//
//  PlanetCell.swift
//  PlanetsIOS
//
//  Created by Martin Doyle on 24/04/2023.
//

import UIKit

public final class PlanetCell: UITableViewCell {
    
    public var isLoading: Bool = false {
        didSet {
            if isLoading {
                startLoading()
            } else {
                stopLoading()
            }
        }
    }
    
    @IBOutlet private(set) public var nameLabel: UILabel!
    @IBOutlet private(set) public var populationLabel: UILabel!
    @IBOutlet private(set) public var moviesLabel: UILabel!
    @IBOutlet private(set) public var activityIndicator: UIActivityIndicatorView!

    
    public func startLoading() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    public func stopLoading() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
}


