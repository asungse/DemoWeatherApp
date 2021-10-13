//
//  Demo.swift
//  Weather
//
//  Created by Alvin on 10/10/2021.
//

import SwiftUI

struct Demo {
    // Use for demo display only
    // Pack API response (weather information only) into one string for one Text() for displaying details
    static func packApiResponseDetailsForCurrentWeather(_ apiResponse: ApiResponse?) -> String {
        var output = ""
        if let desc = apiResponse?.weather?.first?.description {
            output += NSLocalizedString("text.weather.description", comment: "") + desc + "\n"
        }
        if let temp = apiResponse?.main?.temp {
            output += NSLocalizedString("text.current.temperature", comment: "") + String(format: "%.2f °C", temp) + "\n"
        }
        if let feelTemp = apiResponse?.main?.feels_like {
            output += NSLocalizedString("text.feels.like.temperature", comment: "") + String(format: "%.2f °C", feelTemp) + "\n"
        }
        if let minTemp = apiResponse?.main?.temp_min, let maxTemp = apiResponse?.main?.temp_max {
            output += NSLocalizedString("text.temperature.range", comment: "") + String(format: "%.2f - %.2f °C", minTemp, maxTemp) + "\n"
        }
        else if let minTemp = apiResponse?.main?.temp_min {
            output += NSLocalizedString("text.minimum.temperature", comment: "") + String(format: "%.2f °C", minTemp) + "\n"
        }
        else if let maxTemp = apiResponse?.main?.temp_max {
            output += NSLocalizedString("text.maximum.temperature", comment: "") + String(format: "%.2f °C", maxTemp) + "\n"
        }
        if let pressure = apiResponse?.main?.pressure {
            output += NSLocalizedString("text.atmospheric.pressure", comment: "") + "\(pressure) hPa" + "\n"
        }
        if let humidity = apiResponse?.main?.humidity {
            output += NSLocalizedString("text.humidity", comment: "") + "\(humidity)%" + "\n"
        }
        if let seaLevel = apiResponse?.main?.sea_level {
            output += NSLocalizedString("text.atmospheric.pressure.sea.level", comment: "") + "\(seaLevel)" + "\n"
        }
        if let grndLevel = apiResponse?.main?.grnd_level {
            output += NSLocalizedString("text.atmospheric.preesure.ground.level", comment: "") + "\(grndLevel)" + "\n"
        }
        if let windSpeed = apiResponse?.wind?.speed {
            output += NSLocalizedString("text.wind.speed", comment: "") + String(format: "%.2f", windSpeed) + " meter/sec" + "\n"
        }
        if let windDeg = apiResponse?.wind?.deg {
            output += NSLocalizedString("text.wind.direction", comment: "") + "\(windDeg)°" + "\n"
        }
        if let windGust = apiResponse?.wind?.gust {
            output += NSLocalizedString("text.wind.gust", comment: "") + String(format: "%.2f", windGust) + " meter/sec" + "\n"
        }
        if let cloudiness = apiResponse?.clouds?.all {
            output += NSLocalizedString("text.cloudiness", comment: "") + "\(cloudiness)%" + "\n"
        }
        if let rain1h = apiResponse?.rain?._1h {
            output += NSLocalizedString("text.rain.1h", comment: "") + "\(rain1h) mm" + "\n"
        }
        if let rain3h = apiResponse?.rain?._3h {
            output += NSLocalizedString("text.rain.3h", comment: "") + "\(rain3h) mm" + "\n"
        }
        if let snow1h = apiResponse?.snow?._1h {
            output += NSLocalizedString("text.snow.1h", comment: "") + "\(snow1h) mm" + "\n"
        }
        if let snow3h = apiResponse?.snow?._3h {
            output += NSLocalizedString("text.snow.3h", comment: "") + "\(snow3h) mm" + "\n"
        }
        if let sunrise = apiResponse?.sys?.sunrise {
            output += NSLocalizedString("text.sunrise.time", comment: "") + "\(Date(timeIntervalSince1970: TimeInterval(sunrise)))" + "\n"
        }
        if let sunset = apiResponse?.sys?.sunset {
            output += NSLocalizedString("text.sunset.time", comment: "") + "\(Date(timeIntervalSince1970: TimeInterval(sunset)))" + "\n"
        }
        if let dt = apiResponse?.dt {
            output += NSLocalizedString("text.data.calc.time", comment: "") + "\(Date(timeIntervalSince1970: TimeInterval(dt)))" + "\n"
        }
        return output
    }
}
