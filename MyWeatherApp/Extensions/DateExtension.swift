//
//  DateExtension.swift
//  MyWeatherApp
//
//  Created by Kostya on 1/13/22.
//

import UIKit

extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
    }
}
