//
//  DetailScreenViewModel.swift
//  MyMovie
//
//  Created by Gia Nguyen on 11/08/2022.
//

import Foundation
class DetailScreenViewModel {
    fileprivate var movieModel: MovieModel
    
    init(model: MovieModel) {
        movieModel = model
    }
    
    //MARK: - Attributes for view
    var price: String? {
        movieModel.trackPrice != nil ? "Price: \(movieModel.currency)$\(String(movieModel.trackPrice!))" : nil
    }
    
    var genre: String {
        "Genre: " + movieModel.primaryGenreName
    }
    
    var trackName: String? {
        movieModel.trackName
    }
    
    var artworkUrl: URL? {
        URL(string: movieModel.artworkUrl100)
    }
    
    var description: String? {
        movieModel.longDescription
    }
    
    var isFavorited: Bool {
        movieModel.isFavorited
    }
}
