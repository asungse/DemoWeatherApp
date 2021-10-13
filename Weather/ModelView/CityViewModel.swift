//
//  CityViewModel.swift
//  Weather
//
//  Created by Alvin on 10/10/2021.
//

import CoreLocation
import ObjectBox
import UIKit

protocol CityViewModelDelegate {
    func showNeedUpdateGpsAuthorizationAlert()
    func updateUIWithWeatherResult(_ result: Result<Bool, Error>)
}

final class CityViewModel: ObservableObject, LocationManagerDelegate {
    @Published private(set) var apiResponse: ApiResponse?
    
    lazy var locationManager = LocationManager()
    var delegate: CityViewModelDelegate?
    
    // For showing last searched city's weather information at app launch
    private(set) var lastSearchedCity: City?
    
    // For cases which city name returned by API is different from the inputted city name on preload list
    private(set) var selectedCityName: String?
    
    init() {
        City.shared.createObjectBoxStoreIfNotExist()
        City.shared.saveCitiesIntoDBIfNotExist()
        lastSearchedCity = City.shared.getLastSearchedCityFromBox()
    }
    
    // MARK: - Functions to be called by View
    
    func search(text: String) {
        guard !text.isEmpty else { return }
        if let zip = Int(text) {
            loadWeather(zip: zip)
        }
        else {
            loadWeather(cityName: text)
        }
    }
    
    func loadWeather(cityName: String) {
        selectedCityName = cityName
        NetworkManager.shared.getWeather(cityName: cityName.replacingOccurrences(of: " ", with: "%20")) { [weak self] (data, response, error) in
            guard let self = self else { return }
            self.handleApiResponse(data: data, response: response, error: error)
        }
    }
    
    func loadWeather(zip: Int) {
        selectedCityName = nil
        NetworkManager.shared.getWeather(zip: zip) { [weak self] (data, response, error) in
            guard let self = self else { return }
            self.handleApiResponse(data: data, response: response, error: error)
        }
    }
    
    func loadWeatherByGPS() {
        selectedCityName = nil
        guard locationManager.currentCoordinate != nil else { return }
        NetworkManager.shared.getWeather(coordinate: locationManager.currentCoordinate!) { [weak self] (data, response, error) in
            guard let self = self else { return }
            self.handleApiResponse(data: data, response: response, error: error)
        }
    }
    
    func requestGPS() {
        locationManager.delegate = self
        locationManager.checkAuthorizationStatus()
    }
    
    func lastSearchCityIsShowedAtLaunch() {
        lastSearchedCity = nil
    }
    
    func getCities(nameWithPrefix: String, inSearchHistoryOnly: Bool) -> [City] {
        return City.shared.getFromBox(cityNameWithPrefix: nameWithPrefix, inSearchHistoryOnly: inSearchHistoryOnly) ?? [City]()
    }
    
    func updateCities(_ cities: [City], inSearchHistory: Bool) {
        City.shared.updateBox(cities: cities, inSearchHistory: false)
    }
    
    // MARK: - Openweathermap API related functions
    
    private func handleApiResponse(data: Data?, response: URLResponse?, error: Error?) {
        guard error == nil else {
            self.delegate?.updateUIWithWeatherResult(.failure(error!))
            return
        }
        guard let data = data else {
            return
        }
        DispatchQueue.main.async {
            do {
                self.apiResponse = try JSONDecoder().decode(ApiResponse.self, from: data)
                var success = false
                if let cod = self.apiResponse?.cod {
                    if cod == NetworkManager.shared.apiSuccessCode {
                        success = true
                        if let id = self.apiResponse?.id, let name = self.selectedCityName ?? self.apiResponse?.name {
                            let city = City.shared.getFromBox(cityName: name)?.first ?? City(id: id, name: name)
                            City.shared.updateBox(city: city, inSearchHistory: true)
                        }
                    }
                }
                self.delegate?.updateUIWithWeatherResult(.success(success))
            }
            catch let error {
                self.delegate?.updateUIWithWeatherResult(.failure(error))
            }
        }
    }
    
    // MARK: - Protocol - LocationManagerDelegate
    
    func didUpdateCoordinate() {
        loadWeatherByGPS()
    }
    func showNeedUpdateGpsAuthorizationAlert() {
        delegate?.showNeedUpdateGpsAuthorizationAlert()
    }
}
