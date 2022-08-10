//
//  FeaturedScreenViewModel.swift
//  MyMovie
//
//  Created by Gia Nguyen on 07/08/2022.
//

import Foundation
import UIKit.UIApplication
import CoreData
import Alamofire

final class FeaturedScreenViewModel: CoreDataNotification {
    
    fileprivate let networkRequest: NetworkRequestProtocol
    fileprivate var listMovies: ListMovieModel
    
    var notifyViewDataDidChange: ((_ atIndex: IndexPath?) -> Void)?
    
    //MARK: - Initialization
    init() {
        self.networkRequest = NetworkRequest()
        self.listMovies = ListMovieModel()
    }
    
    init(networkRequest: NetworkRequestProtocol) {
        self.networkRequest = networkRequest
        self.listMovies = ListMovieModel()
    }
    
    //MARK: - Register notification
    func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(localDataDidChange(_:)), name: NSNotification.Name(CoreDataNotificationKeys.coreDataDidChange.rawValue), object: nil)
    }
    
    
    //MARK: - Network retrieval
    func fetchListMovie(completion: ((_ atIndex: IndexPath?) -> Void)? = nil) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MovieItem")
        do {
            let listData = try managedContext.fetch(fetchRequest)
            if listData.isEmpty {
                throw CoreDataError.emptyData
            }
            self.listMovies.results = listData.map({ MovieModel(fromCoreDataObject: $0) })
            completion?(nil)
        }
        catch {
            networkRequest.request(ListMovieModel.self, endpoint: NetworkEndpoints.listMovies(searchName: "star")) { [weak self] res in
                switch res {
                case .success(let data):
                    self?.listMovies = data
                    data.results.forEach({ $0.save(isNeedNotify: false) })
                case .failure(_):
                    break
                }
                completion?(nil)
            }
        }
    }
    
    @objc func localDataDidChange(_ notification: Notification) {
        guard let movieModelItem = notification.userInfo?["MovieModel"] as? MovieModel else { return }
        if let itemIndex = listMovies.results.firstIndex(where: { $0.trackID == movieModelItem.trackID }) {
            listMovies.results[itemIndex] = movieModelItem
            notifyViewDataDidChange?(IndexPath(row: itemIndex, section: 0))
        }
    }
    
    //MARK: - Attributes for view
    var totalItem: Int {
        self.listMovies.results.count
    }
    
    func getItem(atIndex: IndexPath) -> (isValidItem: Bool, artworkUrl: String, trackName: String?, price: String?, genre: String?) {
        guard let item = self.listMovies.results[safe: atIndex.row] else { return (false, "", nil, nil, nil) }
        let price:String? = item.trackPrice != nil ? "Price: \(item.currency)$\(String(item.trackPrice!))" : nil
        let genre:String = "Genre: " + item.primaryGenreName
        return (true, item.artworkUrl100, item.trackName, price, genre)
    }
    
    func getIsFavorited(atIndex: IndexPath) -> Bool {
        guard let item = self.listMovies.results[safe: atIndex.row] else { return false }
        return item.isFavorited
    }
    
    func toggleFavoriteItem(_ atIndex: IndexPath, _ cell: MovieItemCell) {
        guard self.listMovies.results[safe: atIndex.row] != nil else { return }
        self.listMovies.results[atIndex.row].isFavorited.toggle()
        self.listMovies.results[atIndex.row].save(isNeedNotify: true)
        cell.updateFavoriteIcon(isFavorite: self.listMovies.results[atIndex.row].isFavorited)
    }
    
    func getItemDetailViewModel(atIndex: IndexPath) -> DetailScreenViewModel? {
        guard let item = self.listMovies.results[safe: atIndex.row] else { return nil }
        return DetailScreenViewModel(model: item)
    }
    
    //MARK: - Deinit
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(CoreDataNotificationKeys.coreDataDidChange.rawValue), object: nil)
    }
}
