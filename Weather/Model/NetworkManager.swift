//
//  NetworkManager.swift
//  Weather
//
//  Created by Alvin on 10/10/2021.
//

import Foundation
import CoreLocation

final class NetworkManager {
    static let shared = NetworkManager()
    let apiSuccessCode = 200
    
    // Current weather data - https://openweathermap.org/current
    private let apiBaseURL = "https://api.openweathermap.org/data/2.5/"
    private let apiKey = "95d190a434083879a6398aafd54d9e73"
    private let mode = "JSON"
    private let unit = "metric"
    
    // Weather icon - https://openweathermap.org/weather-conditions
    private let iconBaseURL = "https://openweathermap.org/img/wn/"
    private let iconURLSuffix = "@2x.png"
    
    private func getWeather(apiURL: String, completed: @escaping (Data?, URLResponse?, Error?) -> Void) {
        guard let url = URL(string: apiURL) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            completed(data, response, error)
        }
        task.resume()
    }
    
    func getWeather(cityName: String, completed: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let apiURL = apiBaseURL + "weather?q=\(cityName)&mode=\(mode)&units=\(unit)&appid=\(apiKey)"
        getWeather(apiURL: apiURL) { data, response, error in
            completed(data, response, error)
        }
    }
    
    func getWeather(zip: Int, completed: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let apiURL = apiBaseURL + "weather?zip=\(zip)&mode=\(mode)&units=\(unit)&appid=\(apiKey)"
        getWeather(apiURL: apiURL) { data, response, error in
            completed(data, response, error)
        }
    }
    
    func getWeather(coordinate: CLLocationCoordinate2D, completed: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let apiURL = apiBaseURL + "weather?lat=\(coordinate.latitude)&lon=\(coordinate.longitude)&mode=\(mode)&units=\(unit)&appid=\(apiKey)"
        getWeather(apiURL: apiURL) { data, response, error in
            completed(data, response, error)
        }
    }
    
    func getIconURL(icon: String?) -> URL? {
        guard let icon = icon else { return nil }
        return URL(string: iconBaseURL + icon + iconURLSuffix)
    }
}
