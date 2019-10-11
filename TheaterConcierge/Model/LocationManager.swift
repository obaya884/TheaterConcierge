//
//  LocationManager.swift
//  TheaterConcierge
//
//  Created by 大林拓実 on 2019/10/11.
//  Copyright © 2019 大林拓実. All rights reserved.
//

import UIKit
import CoreLocation


class LocationManager: NSObject, CLLocationManagerDelegate {
    
    static let sharedInstance = LocationManager()
    let locationManager: CLLocationManager

    var currentAddress: String = ""
    
    override init() {
        locationManager = CLLocationManager()        
        super.init()
        locationManager.delegate = self
    }
    
    func getLocation(){
        locationManager.requestLocation()
//        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization() // 起動中のみの取得許可を求める
            break
        case .denied:
            // 「設定 > プライバシー > 位置情報サービス で、位置情報サービスの利用を許可して下さい」を表示する
            break
        case .restricted:
            // 「このアプリは、位置情報を取得できないために、正常に動作できません」を表示する
            break
        case .authorizedAlways:
            manager.startUpdatingLocation()
            break
        case .authorizedWhenInUse:
            break
        @unknown default:
            fatalError()
        }
    }

    // requestLocation()を使用する場合、失敗した際のDelegateメソッドの実装が必須
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("位置情報の取得に失敗しました")
    }

    // 取得した位置情報をここで受け取る
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }

        CLGeocoder().reverseGeocodeLocation(location) { [unowned self] placemarks, error in
            guard let placemark = placemarks?.first, error == nil else { return }
            
            // 取れていないプロパティがあった際の回避
            let administrativeArea = placemark.administrativeArea ?? ""
            let locality = placemark.locality ?? ""
            let thoroughafare = placemark.thoroughfare ?? ""
            let subThoroughfare = placemark.subThoroughfare ?? ""
            
            self.currentAddress = administrativeArea + locality + thoroughafare + subThoroughfare
       }
    }
}
