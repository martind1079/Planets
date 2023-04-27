//
//  Strings.swift
//  PlanetsIOS
//
//  Created by Martin Doyle on 27/04/2023.
//

import UIKit

extension UIImage {
    enum Planet {
        static let backgroundImage = UIImage(
            named: "stars",
            in: Bundle(for: PlanetsViewController.self),
            compatibleWith: nil)!
    }

}
