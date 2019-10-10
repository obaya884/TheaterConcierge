//
//  ViewController.swift
//  TheaterConcierge
//
//  Created by 大林拓実 on 2019/10/05.
//  Copyright © 2019 大林拓実. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

final class MovieListViewController: UIViewController {
    
    private var datasource: MovieListTableViewDataSource?
    private let firebaseManager = FirebaseManager.shared

    @IBOutlet private var movieListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.setupTableView(_:)), name: .firestoreInitialLoadingFinishNotification, object: nil)
    }

    @objc func setupTableView(_ notification: Notification) {
        datasource = MovieListTableViewDataSource()
        movieListTableView.register(UINib(nibName: "MovieListTableViewCell", bundle: nil), forCellReuseIdentifier: "movieListTableViewCell")
        movieListTableView.delegate = datasource
        movieListTableView.dataSource = datasource
        movieListTableView.reloadData()
        movieListTableView.delegate = self
    }
    
    @IBAction func goToAddScene() {
        self.performSegue(withIdentifier: "AddScheduleViewControllerSegue", sender: nil)
    }
}

extension MovieListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Defaults[.movieListOrder] = indexPath.row
        self.performSegue(withIdentifier: "MovieDetailViewControllerSegue", sender: nil)
    }
}
