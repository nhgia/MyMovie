//
//  MovieItemCell.swift
//  MyMovie
//
//  Created by Gia Nguyen on 07/08/2022.
//

import UIKit
import Kingfisher

class MovieItemCell: UITableViewCell {
    @IBOutlet weak var artworkImage: UIImageView!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var actionTappedFavoriteButton: ((_ index: IndexPath, _ cell: MovieItemCell) -> Void)?
    var indexPath: IndexPath = IndexPath()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupViewCell(index: IndexPath, artworkUrl: String, trackName: String?, price: String?, genre: String?) {
        self.indexPath = index
        let url = URL(string: artworkUrl)
        artworkImage.kf.setImage(with: url, placeholder: UIImage(named: "no-image")!, options: [.cacheOriginalImage], progressBlock: nil, completionHandler: nil)
        trackNameLabel.text = trackName
        priceLabel.text = price
        genreLabel.text = genre
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        /// first, cancel currenct download task
        artworkImage.kf.cancelDownloadTask()
        
        /// second, prevent kingfisher from setting previous image
        artworkImage.kf.setImage(with: URL(string: ""))
        artworkImage.image = nil
    }
    
    func updateFavoriteIcon(isFavorite: Bool) {
        if isFavorite {
            self.favoriteButton.setImage(UIImage(named: "star-checked")!, for: .normal)
        }
        else {
            self.favoriteButton.setImage(UIImage(named: "star-uncheck")!, for: .normal)
        }
    }

    @IBAction func actionTappedFavorite(_ sender: Any) {
        actionTappedFavoriteButton?(indexPath, self)
    }
}
