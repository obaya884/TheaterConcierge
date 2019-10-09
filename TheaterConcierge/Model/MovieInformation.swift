//
//  MovieInformation.swift
//  TheaterConcierge
//
//  Created by 大林拓実 on 2019/10/07.
//  Copyright © 2019 大林拓実. All rights reserved.
//

import Foundation

final class MovieInformation {
    
    var movieTitle: String
    
    var appreciationDate: String
    var appreciationTime: String
    
    var theaterName: String
    var sheetNumber: String
    var confirmationNumber: String
    var reviewMemo: String
    
    init(movieTitle: String,
         appreciationDate: String,
         appreciationTime: String,
         theaterName: String,
         sheetNumber: String,
         confirmationNumber: String,
         reviewMemo: String) {
        
        self.movieTitle = movieTitle
        self.appreciationDate = appreciationDate
        self.appreciationTime = appreciationTime
        self.theaterName = theaterName
        self.sheetNumber = sheetNumber
        self.confirmationNumber = confirmationNumber
        self.reviewMemo = reviewMemo
    }
}
