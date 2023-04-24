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
    
    public let nameLabel = UILabel()
    public let populationLabel = UILabel()
    public let activityIndicator = UIActivityIndicatorView()
    public let moviesLabel = UILabel()
    
    public func startLoading() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    public func stopLoading() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
}


