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
import SafariServices

final class MovieTravelRouteViewController: UIViewController {

    private var locationManager: CLLocationManager?

    private let movieInfoArray = FirebaseManager.shared.movieInfoArray
    private let movieListOrder: Int = Defaults[.movieListOrder]
    
    private var currentAddress = LocationManager.sharedInstance.currentAddress
    
    @IBOutlet var webView: WKWebView!
    @IBOutlet var webContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        routeSearchByYahooTransit()
    }
        
    func routeSearchByYahooTransit() {
        let movieInfo = movieInfoArray[movieListOrder]
        
        // 上映日時をDate型に変換
        let dateString = movieInfo.appreciationDate + " " + movieInfo.appreciationTime
        let appreciationDateAndTime = dateFromString(string: dateString, format: "yyyy/MM/dd HH:mm")
        //Date演算(20分前にする)
        let modifiedDate = Calendar.current.date(byAdding: .minute, value: -20, to: appreciationDateAndTime)!
        // Strng型に再変換
        let modifiedDateString = stringFromDate(date: modifiedDate, format: "yyyy/MM/dd HH:mm")
        let modifiedAppreciationDate = modifiedDateString.prefix(10)
        let modifiedAppreciationTime = modifiedDateString.suffix(5)
        
        // URLパラメータ生成
        let from: String = "?from=" + currentAddress
        let to: String = "&to=" + movieInfo.theaterName
        
        let year: String = "&y=" + String(modifiedAppreciationDate.prefix(4))
        let month: String = "&m=" + String(modifiedAppreciationDate[modifiedAppreciationDate.index(modifiedAppreciationDate.startIndex, offsetBy: 5)...modifiedAppreciationDate.index(modifiedAppreciationDate.startIndex, offsetBy: 6)])
        let day: String = "&d=" + String(modifiedAppreciationDate[modifiedAppreciationDate.index(modifiedAppreciationDate.startIndex, offsetBy: 8)...modifiedAppreciationDate.index(modifiedAppreciationDate.startIndex, offsetBy: 9)])
        
        let hour = "&hh=" + modifiedAppreciationTime.prefix(2)
        let minute_1 = "&m1=" + String(modifiedAppreciationTime[modifiedAppreciationTime.index(modifiedAppreciationTime.startIndex, offsetBy: 3)...modifiedAppreciationTime.index(modifiedAppreciationTime.startIndex, offsetBy: 3)])
        let minute_2 = "&m2=" + modifiedAppreciationTime.suffix(1)
        
        let keyword = "&kw=" + movieInfo.theaterName
        
        let requestUrl: String =
            "https://transit.yahoo.co.jp/search/result" + from + to + year + month + day + hour + minute_2 + minute_1 + "&type=4&ticket=ic&expkind=1&ws=3&s=0&lb=1" + keyword

        if let url = NSURL(string: requestUrl.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!) {
            print(requestUrl)
            let request = NSURLRequest(url: url as URL)
            // TODO: web版が表示されるので、SafariViewとかで綺麗に表示したい
            webView.load(request as URLRequest)
        }
    }
    
    //MARK: 日時変換
    func stringFromDate(date: Date, format: String) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    func dateFromString(string: String, format: String) -> Date {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = format
        return formatter.date(from: string)!
    }

}
