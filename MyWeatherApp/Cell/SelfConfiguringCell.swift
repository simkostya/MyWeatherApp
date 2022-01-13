//
//  SelfConfiguringCell.swift
//  MyWeatherApp
//
//  Created by Kostya on 1/13/22.
//

import UIKit

protocol SelfConfiguringCell {
    static var reuseIdentifier: String { get }
    func configure(with item: ForecastTemperature)
}
