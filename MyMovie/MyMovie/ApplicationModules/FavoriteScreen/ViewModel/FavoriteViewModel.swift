//
//  FavoriteViewModel.swift
//  MyMovie
//
//  Created by Gia Nguyen on 08/08/2022.
//

import Foundation
import UIKit.UIApplication
import CoreData

class FavoriteViewModel: CoreDataNotification {
    fileprivate var listFavoriteMovies: [MovieModel] = []
    
    var notifyViewDataDidChange: ((_ atIndex: IndexPath?) -> Void)?
    
    //MARK: - Register notification
    func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(localDataDidChange(_:)), name: NSNotification.Name(CoreDataNotificationKeys.coreDataDidChange.rawValue), object: nil)
    }
    
    //MARK: - Core Data retrieval
    func fetchListFavoriteMovies(completion: ((_ atIndex: IndexPath?) -> Void)? = nil) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MovieItem")
        fetchRequest.predicate = NSPredicate(format: "isFavorited = YES")
        do {
            let listData = try managedContext.fetch(fetchRequest)
            if listData.isEmpty {
                throw CoreDataError.emptyData
            }
            self.listFavoriteMovies = listData.map({ MovieModel(fromCoreDataObject: $0) })
            completion?(nil)
        }
        catch {
        }
    }
    
    @objc func localDataDidChange(_ notification: Notification) {
        fetchListFavoriteMovies(completion: notifyViewDataDidChange)
    }
    
    //MARK: - Attributes for view
    var totalItem: Int {
        self.listFavoriteMovies.count
    }
    
    func getItem(atIndex: IndexPath) -> (isValidItem: Bool, artworkUrl: String, trackName: String?, price: String?, genre: String?) {
        guard let item = self.listFavoriteMovies[safe: atIndex.row] else { return (false, "", nil, nil, nil) }
        let price:String? = item.trackPrice != nil ? "Price: \(item.currency)$\(String(item.trackPrice!))" : nil
        let genre:String = "Genre: " + item.primaryGenreName
        return (true, item.artworkUrl100, item.trackName, price, genre)
    }
    
    func toggleItem(_ atIndex: IndexPath) {
        guard self.listFavoriteMovies[safe: atIndex.row] != nil else { return }
        self.listFavoriteMovies[atIndex.row].isFavorited.toggle()
        self.listFavoriteMovies[atIndex.row].save(isNeedNotify: true)
    }
    
    func getItemDetailViewModel(atIndex: IndexPath) -> DetailScreenViewModel? {
        guard let item = self.listFavoriteMovies[safe: atIndex.row] else { return nil }
        return DetailScreenViewModel(model: item)
    }
    
    //MARK: - Deinit
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(CoreDataNotificationKeys.coreDataDidChange.rawValue), object: nil)
    }
}
