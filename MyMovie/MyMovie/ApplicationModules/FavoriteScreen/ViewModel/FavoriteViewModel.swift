//
//  FavoriteViewModel.swift
//  MyMovie
//
//  Created by Gia Nguyen on 08/08/2022.
//

import Foundation
import UIKit.UIApplication
import CoreData

class FavoriteViewModel {
    fileprivate var listFavoriteMovies: [MovieModel] = []
    
    //MARK: - Core Data retrieval
    func fetchListFavoriteMovies(completion: (() -> Void)? = nil) {
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
            completion?()
        }
        catch {
        }
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
}
