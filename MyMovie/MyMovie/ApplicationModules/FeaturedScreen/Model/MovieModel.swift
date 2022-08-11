//
//  ListMovieModel.swift
//  MyMovie
//
//  Created by Gia Nguyen on 07/08/2022.
//

import Foundation
import CoreData
import UIKit.UIApplication

struct MovieModel: Codable, ModelPersistence {
    var wrapperType: String
    var kind: String?
    var collectionID, trackID: Int?
    var artistName: String
    var collectionName, trackName, collectionCensoredName, trackCensoredName: String?
    var collectionArtistID: Int?
    var collectionArtistViewURL, collectionViewURL, trackViewURL: String?
    var previewURL: String
    var artworkUrl30: String?
    var artworkUrl60, artworkUrl100: String
    var collectionPrice: Double
    var trackPrice, trackRentalPrice, collectionHDPrice, trackHDPrice: Double?
    var trackHDRentalPrice: Double?
    var releaseDate: String
    var collectionExplicitness: String
    var trackExplicitness: String?
    var discCount, discNumber, trackCount, trackNumber: Int?
    var trackTimeMillis: Int?
    var country: String
    var currency: String
    var primaryGenreName: String
    var contentAdvisoryRating: String?
    var shortDescription, longDescription: String?
    var hasITunesExtras: Bool?
    var artistID: Int?
    var artistViewURL: String?
    var isStreamable: Bool?
    var collectionArtistName, resultDescription: String?
    var isFavorited: Bool = false

    enum CodingKeys: String, CodingKey {
        case wrapperType, kind
        case collectionID = "collectionId"
        case trackID = "trackId"
        case artistName, collectionName, trackName, collectionCensoredName, trackCensoredName
        case collectionArtistID = "collectionArtistId"
        case collectionArtistViewURL = "collectionArtistViewUrl"
        case collectionViewURL = "collectionViewUrl"
        case trackViewURL = "trackViewUrl"
        case previewURL = "previewUrl"
        case artworkUrl30, artworkUrl60, artworkUrl100, collectionPrice, trackPrice, trackRentalPrice
        case collectionHDPrice = "collectionHdPrice"
        case trackHDPrice = "trackHdPrice"
        case trackHDRentalPrice = "trackHdRentalPrice"
        case releaseDate, collectionExplicitness, trackExplicitness, discCount, discNumber, trackCount, trackNumber, trackTimeMillis, country, currency, primaryGenreName, contentAdvisoryRating, shortDescription, longDescription, hasITunesExtras
        case artistID = "artistId"
        case artistViewURL = "artistViewUrl"
        case isStreamable, collectionArtistName
        case resultDescription = "description"
    }
    
    init(fromCoreDataObject object: NSManagedObject) {
        self.artistName = object.value(forKeyPath: "artistName") as? String ?? ""
        self.artworkUrl100 = object.value(forKeyPath: "artworkUrl100") as? String ?? ""
        self.isFavorited = object.value(forKeyPath: "isFavorited") as? Bool ?? false
        self.longDescription = object.value(forKeyPath: "longDescription") as? String
        self.primaryGenreName = object.value(forKeyPath: "primaryGenreName") as? String ?? ""
        self.releaseDate = object.value(forKeyPath: "releaseDate") as? String ?? ""
        self.trackID = object.value(forKeyPath: "trackID") as? Int ?? 0
        self.trackName = object.value(forKeyPath: "trackName") as? String
        self.trackPrice = object.value(forKeyPath: "trackPrice") as? Double ?? 0
        self.currency = object.value(forKeyPath: "currency") as? String ?? ""
        self.wrapperType = ""
        self.previewURL = ""
        self.artworkUrl60 = ""
        self.collectionPrice = 0
        self.collectionExplicitness = ""
        self.country = ""
    }
    
    func save(isNeedNotify: Bool) {
        save(isNeedNotify: isNeedNotify, isExemptFavorited: false)
    }
    
    func save(isNeedNotify: Bool, isExemptFavorited: Bool) {
        guard let trackID = trackID, let appDelegate =
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
        else {
            /// Init a new Object from Core Data
            let entity = NSEntityDescription.entity(forEntityName: "MovieItem", in: managedContext)!
            movie = NSManagedObject(entity: entity, insertInto: managedContext)
        }
        
        movie.setValue(artistName, forKeyPath: "artistName")
        movie.setValue(artworkUrl100, forKeyPath: "artworkUrl100")
        if !isExemptFavorited {
            movie.setValue(isFavorited, forKeyPath: "isFavorited")
        }
        movie.setValue(longDescription, forKeyPath: "longDescription")
        movie.setValue(primaryGenreName, forKeyPath: "primaryGenreName")
        movie.setValue(releaseDate, forKeyPath: "releaseDate")
        movie.setValue(trackID, forKeyPath: "trackID")
        movie.setValue(trackName, forKeyPath: "trackName")
        movie.setValue(trackPrice, forKeyPath: "trackPrice")
        movie.setValue(currency, forKeyPath: "currency")
        
        do {
            try managedContext.save()
            if isNeedNotify {
                NotificationCenter.default.post(name: NSNotification.Name(CoreDataNotificationKeys.coreDataDidChange.rawValue), object: nil, userInfo: ["MovieModel": self])
            }
            
        }
        catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    }
    
    func delete() {
        guard let trackID = trackID, let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        managedContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        
        /// Check if there is any existed data in Core Data that has identical trackID
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MovieItem")
        fetchRequest.predicate = NSPredicate(format: "trackID = %d", trackID)
        
        let fetchResults = try? managedContext.fetch(fetchRequest)
        if let item = fetchResults?.first {
            managedContext.delete(item)
            /// Save the deletions to the persistent store
            try? managedContext.save()

        }
    }
}

