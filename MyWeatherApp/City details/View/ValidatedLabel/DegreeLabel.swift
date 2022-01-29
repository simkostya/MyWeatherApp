//
//  DegreeLabel.swift
//  MyWeatherApp
//
//  Created by Kostya on 1/29/22.
//

import UIKit

class DegreeLabel: UILabel {
    override var text: String? {
        didSet {
            validateText()
        }
    }
    
    func validateText() {
        if let labelText = text, labelText.first != "-" && labelText.first != " " {
            text = " " + labelText
        }
    }
}
