//
//  LocationManager.swift
//  Weather
//
//  Created by Alvin on 10/10/2021.
//

import Foundation
import CoreLocation

protocol LocationManagerDelegate {
    func didUpdateCoordinate()
    func showNeedUpdateGpsAuthorizationAlert()
}

final class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = CLLocationManager()
    private(set) var currentCoordinate: CLLocationCoordinate2D?
    var delegate: LocationManagerDelegate?
    
    override init() {
        super.init()
        LocationManager.shared.delegate = self
    }
    
    func checkAuthorizationStatus() {
        switch LocationManager.shared.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            LocationManager.shared.requestLocation()
        case .notDetermined:
            LocationManager.shared.requestWhenInUseAuthorization()
        case .denied, .restricted:
            delegate?.showNeedUpdateGpsAuthorizationAlert()
        default:
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch LocationManager.shared.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            LocationManager.shared.requestLocation()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.first?.coordinate {
            currentCoordinate = coordinate
            delegate?.didUpdateCoordinate()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
