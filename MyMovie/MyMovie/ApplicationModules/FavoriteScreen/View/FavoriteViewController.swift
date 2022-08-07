//
//  FavoriteViewController.swift
//  MyMovie
//
//  Created by Gia Nguyen on 07/08/2022.
//

import UIKit
import Kingfisher
class FavoriteViewController: UIViewController {
    let viewModel = FeaturedScreenViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        KingfisherManager.shared.cache.clearCache()
        //viewModel.fetchListMovie()
        // Do any additional setup after loading the view.
    }

}
