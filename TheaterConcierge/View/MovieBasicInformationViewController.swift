//
//  MovieBasicInformationViewController.swift
//  TheaterConcierge
//
//  Created by 大林拓実 on 2019/10/07.
//  Copyright © 2019 大林拓実. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

final class MovieBasicInformationViewController: UIViewController {

    private let movieInfoArray = FirebaseManager.shared.movieInfoArray
    private let movieListOrder: Int = Defaults[.movieListOrder]
    
    @IBOutlet private var appreciationDateLabel: UILabel!
    @IBOutlet private var appreciationTimeLabel: UILabel!
    @IBOutlet private var theaterNameLabel: UILabel!
    @IBOutlet private var sheetNumberLabel: UILabel!
    @IBOutlet private var confirmationNumberLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let movieInfo = movieInfoArray[movieListOrder]
        appreciationDateLabel.text = movieInfo.appreciationDate
        appreciationTimeLabel.text = movieInfo.appreciationTime
        theaterNameLabel.text = movieInfo.theaterName
        sheetNumberLabel.text = movieInfo.sheetNumber
        confirmationNumberLabel.text = movieInfo.confirmationNumber
    }
    
}
