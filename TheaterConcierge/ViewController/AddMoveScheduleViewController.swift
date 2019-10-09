//
//  AddMoveScheduleViewController.swift
//  TheaterConcierge
//
//  Created by 大林拓実 on 2019/10/07.
//  Copyright © 2019 大林拓実. All rights reserved.
//

import UIKit

final class AddMoveScheduleViewController: UIViewController {
    
    @IBOutlet private var departureTimeTextField: UITextField!
    @IBOutlet private var arrivalTimeTextField: UITextField!
    @IBOutlet private var screenShotImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
    }
    
    @IBAction func jumpToYahooTransit() {
        
    }
    
    @IBAction func jumpToGoogleMap() {
        
    }
    
    @IBAction func addMovieSchedule() {
        
    }
}
