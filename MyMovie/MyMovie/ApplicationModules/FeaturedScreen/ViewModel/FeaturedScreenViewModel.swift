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
    fileprivate var listMoviesFiltered: [MovieModel]
    fileprivate var fetchInfo: FetchInfoModel = FetchInfoModel()
    
    var notifyViewDataDidChange: ((_ atIndex: IndexPath?) -> Void)?
    
    //MARK: - Initialization
    init() {
        self.networkRequest = NetworkRequest()
        self.listMovies = ListMovieModel()
        self.listMoviesFiltered = []
    }
    
    init(networkRequest: NetworkRequestProtocol) {
        self.networkRequest = networkRequest
        self.listMovies = ListMovieModel()
        self.listMoviesFiltered = []
    }
    
    //MARK: - Register notification
    func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(localDataDidChange(_:)), name: NSNotification.Name(CoreDataNotificationKeys.coreDataDidChange.rawValue), object: nil)
    }
    
    
    //MARK: - Network retrieval
    func fetchListMovie(completion: ((_ atIndex: IndexPath?) -> Void)? = nil) {
        networkRequest.request(ListMovieModel.self, endpoint: NetworkEndpoints.listMovies(searchName: "star")) { [weak self] res in
            switch res {
            case .success(let data):
                var fetchItem = FetchInfoModel()
                fetchItem.previousFetchTime = Date().timeIntervalSince1970
                fetchItem.save(isNeedNotify: false)
                self?.listMovies = data
                for i in 0..<(self?.listMovies.results.count ?? 0) {
                    guard let trackID = self?.listMovies.results[i].trackID, let appDelegate =
                    UIApplication.shared.delegate as? AppDelegate else { return }
                    let managedContext = appDelegate.persistentContainer.viewContext
                    managedContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
                    var movie = NSManagedObject()
                    
                    /// Check if there is any existed data in Core Data that has identical trackID
                    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MovieItem")
                    fetchRequest.predicate = NSPredicate(format: "trackID = %d", trackID)
                    
                    let fetchResults = try? managedContext.fetch(fetchRequest)
                    if let item = fetchResults?.first {
                        movie = item
                    }
                    self?.listMovies.results[i].isFavorited = movie.value(forKeyPath: "isFavorited") as? Bool ?? false
                    self?.listMovies.results[i].save(isNeedNotify: false, isExemptFavorited: true)
                }
                self?.listMoviesFiltered = self?.listMovies.results ?? []
                completion?(nil)
            case .failure(_):
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                let managedContext = appDelegate.persistentContainer.viewContext
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MovieItem")
                do {
                    let listData = try managedContext.fetch(fetchRequest)
                    if listData.isEmpty {
                        throw CoreDataError.emptyData
                    }
                    self?.listMovies.results = listData.map({ MovieModel(fromCoreDataObject: $0) })
                    self?.listMoviesFiltered = self?.listMovies.results ?? []
                    completion?(nil)
                }
                catch {
                    
                }
            }
        }
    }
    
    @objc func localDataDidChange(_ notification: Notification) {
        guard let movieModelItem = notification.userInfo?["MovieModel"] as? MovieModel else { return }
        if let itemIndex = listMovies.results.firstIndex(where: { $0.trackID == movieModelItem.trackID }) {
            listMovies.results[itemIndex] = movieModelItem
        }
        
        if let itemIndex = listMoviesFiltered.firstIndex(where: { $0.trackID == movieModelItem.trackID }) {
            listMoviesFiltered[itemIndex] = movieModelItem
            notifyViewDataDidChange?(IndexPath(row: itemIndex, section: 0))
        }
    }
    
    //MARK: - Attributes for view
    var totalItem: Int {
        self.listMoviesFiltered.count
    }
    
    var lastTimeVisited: String {
        let date = Date(timeIntervalSince1970: fetchInfo.previousFetchTime)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        return "Last visited: \(formatter.string(from: date as Date))"
    }
    
    func getItem(atIndex: IndexPath) -> (isValidItem: Bool, artworkUrl: String, trackName: String?, price: String?, genre: String?) {
        guard let item = self.listMoviesFiltered[safe: atIndex.row] else { return (false, "", nil, nil, nil) }
        let price:String? = item.trackPrice != nil ? "Price: \(item.currency)$\(String(item.trackPrice!))" : nil
        let genre:String = "Genre: " + item.primaryGenreName
        return (true, item.artworkUrl100, item.trackName, price, genre)
    }
    
    func getIsFavorited(atIndex: IndexPath) -> Bool {
        guard let item = self.listMoviesFiltered[safe: atIndex.row] else { return false }
        return item.isFavorited
    }
    
    func toggleFavoriteItem(_ atIndex: IndexPath, _ cell: MovieItemCell) {
        guard self.listMoviesFiltered[safe: atIndex.row] != nil else { return }
        self.listMoviesFiltered[atIndex.row].isFavorited.toggle()
        self.listMoviesFiltered[atIndex.row].save(isNeedNotify: true)
        cell.updateFavoriteIcon(isFavorite: self.listMoviesFiltered[atIndex.row].isFavorited)
    }
    
    func getItemDetailViewModel(atIndex: IndexPath) -> DetailScreenViewModel? {
        guard let item = self.listMoviesFiltered[safe: atIndex.row] else { return nil }
        return DetailScreenViewModel(model: item)
    }
    
    //MARK: Search related
    func resetSearch() {
        self.listMoviesFiltered.removeAll()
        self.listMoviesFiltered = self.listMovies.results
        notifyViewDataDidChange?(nil)
    }
    
    func filterItem(byKeyword key: String) {
        self.listMoviesFiltered = self.listMovies.results.filter({ $0.trackName?.lowercased().contains(key.lowercased()) == true })
        notifyViewDataDidChange?(nil)
    }
    
    //MARK: - Deinit
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(CoreDataNotificationKeys.coreDataDidChange.rawValue), object: nil)
    }
}
