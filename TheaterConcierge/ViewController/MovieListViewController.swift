//
//  ViewController.swift
//  TheaterConcierge
//
//  Created by 大林拓実 on 2019/10/05.
//  Copyright © 2019 大林拓実. All rights reserved.
//

import UIKit

class MovieListViewController: UIViewController {
    
    private var datasource: MovieListTableViewDataSource?

    @IBOutlet private var movieListTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
                
        setupTableView()
        movieListTableView.delegate = self

    }
    
    func setupTableView() {
        datasource = MovieListTableViewDataSource()
        movieListTableView.register(UINib(nibName: "MovieListTableViewCell", bundle: nil), forCellReuseIdentifier: "movieListTableViewCell")
        movieListTableView.delegate = datasource
        movieListTableView.dataSource = datasource
    }
    
    @IBAction func goToAddScene() {
        self.performSegue(withIdentifier: "AddScheduleViewControllerSegue", sender: nil)
    }
}

extension MovieListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "MovieDetailViewControllerSegue", sender: nil)
    }
}
