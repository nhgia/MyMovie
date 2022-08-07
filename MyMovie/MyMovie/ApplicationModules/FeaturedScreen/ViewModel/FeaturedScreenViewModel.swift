//
//  FeaturedScreenViewModel.swift
//  MyMovie
//
//  Created by Gia Nguyen on 07/08/2022.
//

import Foundation
final class FeaturedScreenViewModel {
    fileprivate let networkRequest: NetworkRequest<ListMovieModel>
    fileprivate var listMovies: ListMovieModel
    
    //MARK: - Initialization
    init() {
        self.networkRequest = NetworkRequest<ListMovieModel>()
        self.listMovies = ListMovieModel()
    }
    
    init(networkRequest: NetworkRequest<ListMovieModel>) {
        self.networkRequest = networkRequest
        self.listMovies = ListMovieModel()
    }
    
    //MARK: - Network retrieval
    func fetchListMovie(completion: (() -> Void)? = nil) {
        networkRequest.request(endpoint: NetworkEndpoints.listMovies(searchName: "star")) { [weak self] res in
            switch res {
            case .success(let data):
                self?.listMovies = data
            case .failure(_):
                break
            }
            completion?()
        }
    }
    
    //MARK: - Attributes for view
    var totalItem: Int {
        self.listMovies.results.count
    }
    
    func getItem(atIndex: IndexPath) -> (isValidItem: Bool, artworkUrl: String, trackName: String?, price: String?, genre: String?) {
        guard let item = self.listMovies.results[safe: atIndex.row] else { return (false, "", nil, nil, nil) }
        let price:String? = item.trackPrice != nil ? "Price: \(String(item.trackPrice!))" : nil
        let genre:String = "Genre: " + item.primaryGenreName
        return (true, item.artworkUrl100, item.trackName, price, genre)
    }
}
