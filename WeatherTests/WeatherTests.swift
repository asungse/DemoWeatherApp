//
//  WeatherTests.swift
//  WeatherTests
//
//  Created by Alvin on 10/10/2021.
//

import XCTest
@testable import Weather

class WeatherTests: XCTestCase {
    struct CityViewModelTestDelegate: CityViewModelDelegate {
        let expectation = XCTestCase().expectation(description: "CityViewModelTestDelegate to be called")
        
        func showNeedUpdateGpsAuthorizationAlert() {
            expectation.fulfill()
        }
        
        func updateUIWithWeatherResult(_ result: Result<Bool, Error>) {
            expectation.fulfill()
        }
    }
    
    func testSearchByCityName() throws {
        let cityName = "Hong Kong"
        let viewModel = CityViewModel()
        let testDelegate = CityViewModelTestDelegate()
        viewModel.delegate = testDelegate
        viewModel.loadWeather(cityName: cityName)
        wait(for: [testDelegate.expectation], timeout: 5)
        XCTAssert(viewModel.apiResponse != nil)
    }
    
    func testSearchByZipCode() throws {
        let zip = 94040
        let viewModel = CityViewModel()
        let testDelegate = CityViewModelTestDelegate()
        viewModel.delegate = testDelegate
        viewModel.loadWeather(zip: zip)
        wait(for: [testDelegate.expectation], timeout: 5)
        XCTAssert(viewModel.apiResponse != nil)
    }
    
    // Test case for location service authorization granted only
    func testSearchByGps() throws {
        let viewModel = CityViewModel()
        let testDelegate = CityViewModelTestDelegate()
        viewModel.delegate = testDelegate
        switch LocationManager.shared.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            viewModel.requestGPS()
            wait(for: [testDelegate.expectation], timeout: 5)
            XCTAssert(viewModel.apiResponse != nil)
        default:
            break
        }
    }
    
    func testGetLastSearchCityAtLaunch() throws {
        let viewModel = CityViewModel()
        XCTAssert(viewModel.lastSearchedCity == City.shared.getLastSearchedCityFromBox())
    }
    
    func testGetAllSearchHistoryAtLaunch() throws {
        let viewModel = CityViewModel()
        let cities = viewModel.getCities(nameWithPrefix: "", inSearchHistoryOnly: true)
        XCTAssert(cities == City.shared.getAllCitiesInSearchHistory())
    }
    
    func testDeleteSearchRecords() throws {
        let viewModel = CityViewModel()
        let countBeforeDelete = City.shared.getAllCitiesInSearchHistory()?.count ?? 0
        if viewModel.lastSearchedCity != nil {
            viewModel.updateCities([viewModel.lastSearchedCity!], inSearchHistory: false)
        }
        let countAfterDelete = City.shared.getAllCitiesInSearchHistory()?.count ?? 0
        XCTAssert(countBeforeDelete == countAfterDelete + 1 || countBeforeDelete == 0 && countAfterDelete == 0)
    }
}
