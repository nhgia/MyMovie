//
//  FeatureViewController.swift
//  MyMovie
//
//  Created by Gia Nguyen on 07/08/2022.
//

import UIKit

class FeatureViewController: UIViewController {
    @IBOutlet weak var loadingIndicatorView: UIView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = FeaturedScreenViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "MyMovie"
        self.searchBar.showsCancelButton = true
        self.searchBar.layer.borderWidth = 1
        self.searchBar.layer.borderColor = UIColor.clear.cgColor
        self.loadingIndicatorView.layer.cornerRadius = 8.0
        self.loadingIndicatorView.isHidden = false
        self.loadingIndicator.startAnimating()
        setupTableView()
        startCallAPI()
    }
    
    func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func startCallAPI() {
        viewModel.fetchListMovie { [weak self] in
            self?.tableView.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                self?.loadingIndicatorView.isHidden = true
                self?.loadingIndicator.stopAnimating()
            }
        }
    }

}

extension FeatureViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.totalItem
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.getItem(atIndex: indexPath)
        guard item.isValidItem else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieItemCell") as! MovieItemCell
        cell.setupViewCell(artworkUrl: item.artworkUrl, trackName: item.trackName, price: item.price, genre: item.genre)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 144.0
    }
    
}
