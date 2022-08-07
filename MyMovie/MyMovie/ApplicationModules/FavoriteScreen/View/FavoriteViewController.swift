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
    let viewModel = FeaturedScreenViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        KingfisherManager.shared.cache.clearCache()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MovieItem")
        do {
            let listData = try managedContext.fetch(fetchRequest)
            listData.map({ managedContext.delete($0) })
            try? managedContext.save()
        }
        catch {
        }
        //viewModel.fetchListMovie()
        // Do any additional setup after loading the view.
    }

}
