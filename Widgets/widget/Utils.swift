//
//  Utils.swift
//  Widgets
//
//  Created by zhang shijie on 2023/6/15.
//

import Foundation
import WidgetKit
import SwiftUI
import CoreLocation
enum LocationError: Error {
    case authorizationDenied
}


struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let wel:Welcome?
    let city:String
}

class TLocationManager:NSObject,CLLocationManagerDelegate{
  private let locationManager = CLLocationManager()
  var didComplete = false
  private var callback:((CLLocation?)->Void)?
  func requestLocation(callback: @escaping ((CLLocation?)->Void)){
    self.callback = callback;
    self.requestLocationAuthorization();
  }

  private func requestLocationAuthorization(){

    DispatchQueue.main.async {
      self.locationManager.delegate = self
//      self.locationManager.requestWhenInUseAuthorization()
      self.locationManager.requestLocation()
    }
  }

  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    let status = self.locationManager.authorizationStatus
    // 检查位置权限状态
    switch status {
    case .authorizedWhenInUse, .authorizedAlways:
      self.locationManager.requestLocation()
    case .denied, .restricted:
      if let callback = self.callback{
        callback(nil)
      }
    case .notDetermined:
      if let callback = self.callback{
        callback(nil)
      }
      break
    @unknown default:
      if let callback = self.callback{
        callback(nil)
      }
      break
    }
  }

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let currentLocation = locations.last else {
      let defaultLocation = CLLocation(latitude: 0.0, longitude: 0.0)
      handleLocationUpdate(defaultLocation)
      return
    }

    handleLocationUpdate(currentLocation)
  }

  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus){
    switch status {
    case .authorizedWhenInUse, .authorizedAlways:
      self.locationManager.requestLocation()
    case .denied, .restricted:
      if let callback = self.callback{
        callback(nil)
      }
    case .notDetermined:
      if let callback = self.callback{
        callback(nil)
      }
      break
    @unknown default:
      if let callback = self.callback{
        callback(nil)
      }
      break
    }
  }

  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("获取位置信息错误：\(error)")

//    let defaultLocation = CLLocation(latitude: 0.0, longitude: 0.0)
    handleLocationUpdate(nil)
  }

  private func handleLocationUpdate(_ location: CLLocation?) {
    if let callback = self.callback{
      if !didComplete{
        callback(location)
        didComplete = true
      }
    }

  }

}
