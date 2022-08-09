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
//        KingfisherManager.shared.cache.clearCache()
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//        let managedContext = appDelegate.persistentContainer.viewContext
//        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MovieItem")
//        do {
//            let listData = try managedContext.fetch(fetchRequest)
//            listData.forEach({ managedContext.delete($0) })
//            try? managedContext.save()
//        }
//        catch {
//        }
        //viewModel.fetchListMovie()
        // Do any additional setup after loading the view.
        setupTableView()
        startCallAPI()
    }
    
    func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "MovieItemCell", bundle: nil), forCellReuseIdentifier: "MovieItemCell")
    }
    
    func startCallAPI() {
        viewModel.fetchListFavoriteMovies { [weak self] in
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
        //cell.actionTappedFavoriteButton = viewModel.toggleFavoriteItem(_:_:)
        cell.setupViewCell(index: indexPath, artworkUrl: item.artworkUrl, trackName: item.trackName, price: item.price, genre: item.genre)
        cell.updateFavoriteIcon(isFavorite: true)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 144.0
    }
    
}
