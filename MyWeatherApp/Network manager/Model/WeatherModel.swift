//
//  WeatherModel.swift
//  MyWeatherApp
//
//  Created by Kostya on 1/29/22.
//

import Foundation

// Enum for different types of collectionView cells
enum SunStateDescription {
    case sunset
    case sunrise
}

struct SunState {
    let description: SunStateDescription
    let time: Int
}

enum HourlyDataType {
    case weatherType(Hourly)
    case sunState(SunState)
}

struct WeatherModel {

    let lat: Double
    let lon: Double

    let conditionId: Int
    var cityName: String
    let temperature: Double
    let timezone: Int
    let feelsLike: Double
    let description: String

    let humidity: Int
    let uviIndex: Double
    let wind: Double
    let cloudiness: Int
    let pressure: Int
    let visibility: Int

    let sunrise: Int
    let sunset: Int

    let daily: [Daily]
    let hourly: [Hourly]

    var hourlyDisplayData: [HourlyDataType] {
        var hourlyDataMix = [HourlyDataType]()

        // SunType cells data for sunset/sunrise for the current day and the next one
        var sunStates = [SunState(description: .sunrise, time: sunrise),
                         SunState(description: .sunset, time: sunset),
                         SunState(description: .sunrise, time: daily[1].sunrise),
                         SunState(description: .sunset, time: daily[1].sunset)]

        for i in 0...24 {
            let currentHour = hourly[i]

            // Add SunType cell data
            for (i, sunState) in sunStates.enumerated() {
                // Check the next hour syntetically
                // Add sunType cell data after current time cell and before the next time cell
                if sunState.time < currentHour.dt &&  sunState.time > Int(Date().timeIntervalSince1970) {
                    hourlyDataMix.append(HourlyDataType.sunState(SunState(description: sunState.description,
                                                                          time: sunState.time)))
                    sunStates.remove(at: i)
                }
            }
            // Add weather cell data
            let currentTemp = HourlyDataType.weatherType(currentHour)
            hourlyDataMix.append(currentTemp)
        }

        return hourlyDataMix
    }

    var cityRequest: SavedCity {
        return SavedCity(name: cityName, latitude: lat, longitude: lon)
    }

    // Strings
    var humidityString: String {
        String("\(humidity)%")
    }

    var windString: String {
        String("\(wind) m/s")
    }

    var cloudinessString: String {
        String("\(cloudiness)%")
    }

    var pressureString: String {
        String("\(pressure) hPa")
    }

    var visibilityString: String {
        String("\(visibility) m.")
    }

    var feelsLikeString: String {
        String(format: "\(R.string.localizable.feelsLike()) %.0f°", feelsLike)
    }

    var temperatureString: String {
        String(format: "%.0f°", temperature)
    }

    static func getConditionNameBy(conditionId id: Int) -> String {
        switch id {
        case 200...232:
            return K.SystemImageName.cloudBoltFill
        case 300...321:
            return K.SystemImageName.cloudDrizzleFill
        case 500...531:
            return K.SystemImageName.cloudRainFill
        case 600...622:
            return K.SystemImageName.cloudSnowFill
        case 701...781:
            return K.SystemImageName.cloudFogFill
        case 800:
            return K.SystemImageName.sunMaxFill
        case 801...804:
            return K.SystemImageName.cloudFill
        default:
            return "error"
        }
    }
}
