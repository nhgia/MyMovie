//
//  FavoriteViewController.swift
//  MyMovie
//
//  Created by Gia Nguyen on 07/08/2022.
//

import UIKit
import Kingfisher
import CoreData

class FavoriteViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = FavoriteViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Favorites"
        // Do any additional setup after loading the view.
        setupViewModel()
        setupTableView()
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
    
    func startCallAPI() {
        viewModel.fetchListFavoriteMovies { [weak self] _ in
            self?.tableView.reloadData()
        }
    }
}

extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.totalItem
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.getItem(atIndex: indexPath)
        guard item.isValidItem else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieItemCell") as! MovieItemCell
        cell.actionTappedFavoriteButton = { _, _ in
            tableView.setEditing(!tableView.isEditing, animated: true)
        }
        cell.setupViewCell(index: indexPath, artworkUrl: item.artworkUrl, trackName: item.trackName, price: item.price, genre: item.genre)
        cell.updateFavoriteIcon(isFavorite: true)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 144.0
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        viewModel.toggleItem(indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailScreenViewController") as! DetailScreenViewController
        vc.viewModel = viewModel.getItemDetailViewModel(atIndex: indexPath)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
}
