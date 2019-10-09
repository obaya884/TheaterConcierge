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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(firebaseManager.movieInfoArray.count)
        return firebaseManager.movieInfoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieListTableViewCell") as! MovieListTableViewCell
        
        cell.movieTitleLabel.text = firebaseManager.movieInfoArray[indexPath.row].movieTitle
        cell.appreciationDateLabel.text = firebaseManager.movieInfoArray[indexPath.row].appreciationDate
        
        return cell
    }
}
