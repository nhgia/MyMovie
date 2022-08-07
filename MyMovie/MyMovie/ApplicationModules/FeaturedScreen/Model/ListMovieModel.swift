//
//  ListMovieModel.swift
//  MyMovie
//
//  Created by Gia Nguyen on 07/08/2022.
//

import Foundation
struct ListMovieModel: Codable {
    var resultCount: Int
    var results: [MovieModel]
    
    init() {
        self.resultCount = 0
        self.results = []
    }
}
