//
//  AppComponents.swift
//  MyWeatherApp
//
//  Created by Kostya on 1/29/22.
//

import Foundation

protocol ColorThemeProtocol {
    var colorTheme: ColorThemeModel { get set }
}

class AppComponents: ColorThemeProtocol {
    var colorTheme: ColorThemeModel
    
    init(_ colorTheme: ColorThemeModel) {
        self.colorTheme = colorTheme
    }
}
