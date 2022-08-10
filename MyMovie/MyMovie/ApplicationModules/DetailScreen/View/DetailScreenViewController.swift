//
//  DetailScreenViewController.swift
//  MyMovie
//
//  Created by Gia Nguyen on 08/08/2022.
//

import UIKit
import Kingfisher

class DetailScreenViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var viewModel: DetailScreenViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        titleLabel.text = viewModel?.trackName
        priceLabel.text = viewModel?.price
        genreLabel.text = viewModel?.genre
        textView.text = viewModel?.description ?? ""
        imageView.kf.setImage(with: viewModel?.artworkUrl, placeholder: UIImage(named: "no-image")!, options: [.cacheOriginalImage], progressBlock: nil, completionHandler: nil)
        updateFavoriteIcon()
    }
    
    func updateFavoriteIcon() {
        if viewModel?.isFavorited ?? false {
            self.favoriteButton.setImage(UIImage(named: "star-checked")!, for: .normal)
        }
        else {
            self.favoriteButton.setImage(UIImage(named: "star-uncheck")!, for: .normal)
        }
    }
    
    @IBAction func actionTappedFavoriteIcon(_ sender: Any) {
    }
}
