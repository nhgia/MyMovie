//
//  NetworkEndpoints.swift
//  MyMovie
//
//  Created by Gia Nguyen on 07/08/2022.
//

import Foundation
import Alamofire

struct NetworkEndpoints {
    static func listMovies(searchName: String) -> NetworkEndpoint {
        let queryParams: Parameters = [
            "term": searchName,
            "country": "au",
            "media": "movie"
        ]
        return NetworkEndpoint(method: .get, path: "search", isFullPath: false, queryParameters: queryParams)
    }
}
