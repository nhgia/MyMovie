//
//  FetchInfoModel.swift
//  MyMovie
//
//  Created by Gia Nguyen on 12/08/2022.
//

import Foundation
import CoreData
import UIKit.UIApplication

protocol ModelPersistence {
    init(fromCoreDataObject object: NSManagedObject)
    func save(isNeedNotify: Bool)
    func delete()
}


struct FetchInfoModel: Codable, ModelPersistence {
    var id: Int = 0
    var previousFetchTime: Double = 0
    
    init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequestInfo = NSFetchRequest<NSManagedObject>(entityName: "FetchInfo")
        do {
            let fetchInfoContext = try managedContext.fetch(fetchRequestInfo)
            if let fetchItem = fetchInfoContext.first {
                let item = FetchInfoModel(fromCoreDataObject: fetchItem)
                self.previousFetchTime = item.previousFetchTime
            }
        }
        catch {
            
        }
    }
    
    init(fromCoreDataObject object: NSManagedObject) {
        self.previousFetchTime = object.value(forKeyPath: "previousFetchTime") as? Double ?? 0.0
    }
    
    func save(isNeedNotify: Bool) {
        guard let appDelegate =
        UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        managedContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        var movie = NSManagedObject()
        
        /// Check if there is any existed data in Core Data that has identical trackID
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FetchInfo")
        fetchRequest.predicate = NSPredicate(format: "id = %d", id)
        
        let fetchResults = try? managedContext.fetch(fetchRequest)
        if let item = fetchResults?.first {
            movie = item
        }
        else {
            /// Init a new Object from Core Data
            let entity = NSEntityDescription.entity(forEntityName: "FetchInfo", in: managedContext)!
            movie = NSManagedObject(entity: entity, insertInto: managedContext)
        }
        
        movie.setValue(id, forKeyPath: "id")
        movie.setValue(previousFetchTime, forKeyPath: "previousFetchTime")
        
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
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        managedContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        
        /// Check if there is any existed data in Core Data that has identical trackID
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FetchInfo")
        fetchRequest.predicate = NSPredicate(format: "id = %d", id)
        
        let fetchResults = try? managedContext.fetch(fetchRequest)
        if let item = fetchResults?.first {
            managedContext.delete(item)
            /// Save the deletions to the persistent store
            try? managedContext.save()

        }
    }
    
    
}
