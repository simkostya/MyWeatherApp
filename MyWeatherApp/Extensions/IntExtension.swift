//
//  IntExtension.swift
//  MyWeatherApp
//
//  Created by Kostya on 1/13/22.
//

import UIKit

extension Int {
    func incrementWeekDays(by num: Int) -> Int {
        let incrementedVal = self + num
        let mod = incrementedVal % 7
        
        return mod
    }
}
