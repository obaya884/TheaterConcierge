//
//  MovieTravelRouteViewController.swift
//  TheaterConcierge
//
//  Created by 大林拓実 on 2019/10/07.
//  Copyright © 2019 大林拓実. All rights reserved.
//

import UIKit
import WebKit
import CoreLocation
import SwiftyUserDefaults

final class MovieTravelRouteViewController: UIViewController {

    private var locationManager: CLLocationManager?

    private let movieInfoArray = FirebaseManager.shared.movieInfoArray
    private let movieListOrder: Int = Defaults[.movieListOrder]
    
//    private var currentAddress: String = FirebaseManager.shared.currentAddress
    private var currentAddress: String = ""
    
    @IBOutlet var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager() // インスタンスの生成
        locationManager?.delegate = self
        
        // TODO: レスポンスめっちゃ遅い
        locationManager?.requestLocation()
        
        NotificationCenter.default.addObserver(self, selector: #selector(routeSearchByYahooTransit), name: .getCurrentAddressFinishNotification, object: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    
    @objc func routeSearchByYahooTransit() {
        let movieInfo = movieInfoArray[movieListOrder]
        
        let from: String = "?from=" + currentAddress
        let to: String = "&to=" + movieInfo.theaterName
        
        let appreciationDate = movieInfo.appreciationDate
        let year: String = "&y=" + String(appreciationDate.prefix(4))
        let month: String = "&m=" + String(appreciationDate[appreciationDate.index(appreciationDate.startIndex, offsetBy: 5)...appreciationDate.index(appreciationDate.startIndex, offsetBy: 6)])
        let day: String = "&d=" + String(appreciationDate[appreciationDate.index(appreciationDate.startIndex, offsetBy: 8)...appreciationDate.index(appreciationDate.startIndex, offsetBy: 9)])
        
        let appreciationTime = movieInfo.appreciationTime
        let hour = "&hh=" + appreciationTime.prefix(2)
        let minute_1 = "&m1=" + String(appreciationTime[appreciationTime.index(appreciationTime.startIndex, offsetBy: 3)...appreciationTime.index(appreciationTime.startIndex, offsetBy: 3)])
        let minute_2 = "&m2=" + appreciationTime.suffix(1)
        
        let keyword = "&kw=" + movieInfo.theaterName
        
        let requestUrl: String =
            "https://transit.yahoo.co.jp/search/result" + from + to + year + month + day + hour + minute_2 + minute_1 + "&type=4&ticket=ic&expkind=1&ws=3&s=0&lb=1" + keyword

        if let url = NSURL(string: requestUrl.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!) {
            print(requestUrl)
            let request = NSURLRequest(url: url as URL)
            webView.load(request as URLRequest)
        }
    }

}

extension MovieTravelRouteViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager?.requestWhenInUseAuthorization() // 起動中のみの取得許可を求める
            break
        case .denied:
            // 「設定 > プライバシー > 位置情報サービス で、位置情報サービスの利用を許可して下さい」を表示する
            break
        case .restricted:
            // 「このアプリは、位置情報を取得できないために、正常に動作できません」を表示する
            break
        case .authorizedAlways:
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

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }

        CLGeocoder().reverseGeocodeLocation(location) { [unowned self] placemarks, error in
            guard let placemark = placemarks?.first, error == nil else { return }
            // TODO: subThoroughfareまで取れないことがある
            self.currentAddress = placemark.administrativeArea!
                             + placemark.locality!
                             + placemark.thoroughfare!
                             + placemark.subThoroughfare!
            print(self.currentAddress)
            NotificationCenter.default.post(name: .getCurrentAddressFinishNotification, object: nil)
        }
       }
}
