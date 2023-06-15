//
//  HomeViewModel.swift
//  Widgets
//
//  Created by zhang shijie on 2023/6/15.
//

import Foundation
import CoreLocation
class HomeViewModel :ObservableObject{
  private let locationManager = LocationManagerDelegate()
  func requestLocation() {
    locationManager.requestLocation()
  }
}


class LocationManagerDelegate: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()

    override init() {
        super.init()
        locationManager.delegate = self
    }

    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            print("Failed to retrieve location.")
            return
        }

        print("Latitude: \(location.coordinate.latitude)")
        print("Longitude: \(location.coordinate.longitude)")
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location request error: \(error.localizedDescription)")
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            print("Location authorization status: Not determined")
        case .restricted:
            print("Location authorization status: Restricted")
        case .denied:
            print("Location authorization status: Denied")
        case .authorizedAlways:
            print("Location authorization status: Authorized Always")
        case .authorizedWhenInUse:
            print("Location authorization status: Authorized When In Use")
        @unknown default:
            print("Location authorization status: Unknown")
        }
    }
}
