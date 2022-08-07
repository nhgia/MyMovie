//
//  ListMovieModel.swift
//  MyMovie
//
//  Created by Gia Nguyen on 07/08/2022.
//

import Foundation
struct MovieModel: Codable {
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
}

