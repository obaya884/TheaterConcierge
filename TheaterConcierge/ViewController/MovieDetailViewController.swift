//
//  MovieDetailViewController.swift
//  TheaterConcierge
//
//  Created by 大林拓実 on 2019/10/05.
//  Copyright © 2019 大林拓実. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

final class MovieDetailViewController: UIViewController {
    
    private let firebaseManager = FirebaseManager.shared

    @IBOutlet private var segmentControl: UISegmentedControl!
    @IBOutlet private var containerView: UIView!

    private let movieListOrder: Int = Defaults[.movieListOrder]

    private lazy var movieBasicInformationViewController: MovieBasicInformationViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "MovieBasicInformationViewController") as! MovieBasicInformationViewController

        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)

        return viewController
    }()
    
    private lazy var movieTravelRouteViewController: MovieTravelRouteViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "MovieTravelRouteViewController") as! MovieTravelRouteViewController

        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)

        return viewController
    }()
    
    private lazy var movieReviewMemoViewController: MovieReviewMemoViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "MovieReviewMemoViewController") as! MovieReviewMemoViewController

        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)

        return viewController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = FirebaseManager.shared.movieInfoArray[movieListOrder].movieTitle

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        setupView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        firebaseManager.fetchMovieInfo(){
            NotificationCenter.default.post(name: .firestoreInitialLoadingFinishNotification, object: nil)
        }
    }
    
    private func updateView() {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            remove(asChildViewController: movieTravelRouteViewController)
            remove(asChildViewController: movieReviewMemoViewController)
            add(asChildViewController: movieBasicInformationViewController)
        case 1:
            remove(asChildViewController: movieReviewMemoViewController)
            remove(asChildViewController: movieBasicInformationViewController)
            add(asChildViewController: movieTravelRouteViewController)
        case 2:
            remove(asChildViewController: movieTravelRouteViewController)
            remove(asChildViewController: movieTravelRouteViewController)
            add(asChildViewController: movieReviewMemoViewController)
        default:
            add(asChildViewController: movieBasicInformationViewController)
        }
    }
    
    func setupView() {
        updateView()
    }
    
    private func add(asChildViewController viewController: UIViewController) {
        containerView.addSubview(viewController.view)
        
        viewController.view.frame = containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        // Notify Child View Controller
        viewController.didMove(toParent: self)
    }

    private func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParent: nil)

        // Remove Child View From Superview
        viewController.view.removeFromSuperview()

        // Notify Child View Controller
        viewController.removeFromParent()
    }

    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        updateView()
    }
    
}
