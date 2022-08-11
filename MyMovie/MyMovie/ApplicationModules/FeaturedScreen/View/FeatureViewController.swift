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
        self.loadingIndicatorView.layer.cornerRadius = 8.0
        self.loadingIndicatorView.isHidden = false
        self.loadingIndicator.startAnimating()
        setupViewModel()
        setupTableView()
        setupSearchBar()
        startCallAPI()
    }
    
    func setupViewModel() {
        viewModel.registerNotification()
        viewModel.notifyViewDataDidChange = { [weak self] ind in
            guard let ind = ind else {
                self?.tableView.reloadData()
                return
            }
            self?.tableView.reloadRows(at: [ind], with: .automatic)
        }
    }
    
    func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "MovieItemCell", bundle: nil), forCellReuseIdentifier: "MovieItemCell")
    }
    
    func setupSearchBar() {
        self.searchBar.showsCancelButton = false
        self.searchBar.layer.borderWidth = 1
        self.searchBar.layer.borderColor = UIColor.clear.cgColor
        self.searchBar.delegate = self
    }
    
    func startCallAPI() {
        viewModel.fetchListMovie { [weak self] _ in
            self?.tableView.reloadData()
            
            /// Add a 0.5 delay to simulate loading process
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
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
        cell.actionTappedFavoriteButton = viewModel.toggleFavoriteItem(_:_:)
        cell.setupViewCell(index: indexPath, artworkUrl: item.artworkUrl, trackName: item.trackName, price: item.price, genre: item.genre)
        cell.updateFavoriteIcon(isFavorite: viewModel.getIsFavorited(atIndex: indexPath))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 144.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailScreenViewController") as! DetailScreenViewController
        vc.viewModel = viewModel.getItemDetailViewModel(atIndex: indexPath)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.lastTimeVisited
    }
    
}

//MARK: - UISearchBar
extension FeatureViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        /// Add cancelable action (in case for call API search)
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(reloadSearch(_:)), object: searchBar)
        perform(#selector(self.reloadSearch(_:)), with: searchBar, afterDelay: 0.75)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder() 
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
    }
    
    @objc func reloadSearch(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, query.trimmingCharacters(in: .whitespaces) != "" else {
            viewModel.resetSearch()
            return
        }
        
        viewModel.filterItem(byKeyword: query)
    }
}
