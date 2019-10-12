//
//  MovieListTableViewDataSource.swift
//  TheaterConcierge
//
//  Created by 大林拓実 on 2019/10/07.
//  Copyright © 2019 大林拓実. All rights reserved.
//

import Foundation
import UIKit

final class MovieListTableViewDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    private let firebaseManager = FirebaseManager.shared
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return firebaseManager.movieInfoArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
//        return firebaseManager.movieInfoArray.count
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 15))
        footerView.backgroundColor = .white
        return footerView
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieListTableViewCell") as! MovieListTableViewCell
        
        cell.movieTitleLabel.text = firebaseManager.movieInfoArray[indexPath.section].movieTitle
        cell.appreciationDateLabel.text = firebaseManager.movieInfoArray[indexPath.section].appreciationDate
        return cell
    }
}
