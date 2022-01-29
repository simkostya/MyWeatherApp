//
//  ConditionImageConfigurator.swift
//  MyWeatherApp
//
//  Created by Kostya on 1/29/22.
//

import UIKit

protocol ConditionImageColorConfiguratorProtocol {
    var makeColorForSunImage: UIColor { get }
    var makeColorForDefaultImage: UIColor { get }
    var makeColorForCloudImage: UIColor { get }
}

struct StandartConditionImageColorConfigurator: ConditionImageColorConfiguratorProtocol {
    var makeColorForSunImage: UIColor { K.Colors.WeatherIcons.defaultSunColor }
    var makeColorForDefaultImage: UIColor { K.Colors.WeatherIcons.defaultColor }
    var makeColorForCloudImage: UIColor { K.Colors.WeatherIcons.defaultColor }
}

struct WhiteConditionImageColorConfigurator: ConditionImageColorConfiguratorProtocol {
    var makeColorForSunImage: UIColor { .white }
    var makeColorForDefaultImage: UIColor { .white }
    var makeColorForCloudImage: UIColor { .white }
}

struct BlackConditionImageColorConfigurator: ConditionImageColorConfiguratorProtocol {
    var makeColorForSunImage: UIColor { .black }
    var makeColorForDefaultImage: UIColor { .black }
    var makeColorForCloudImage: UIColor { .black }
}

