//
//  MovieDetailsResponse.swift
//  TestMovieDB
//
//  Created by maxim Tartachnik on 19.09.2022.
//

import Foundation

struct MovieDetailsResponse: Codable {
//    let page: Int
//    let totalResults: Int
//    let totalPages: Int
//    let results: [Movie]
    let id: Int
    let originalTitle: String
    let posterPath: String?
    let overview: String
    let voteAverage: Double
    let voteCount: Int
    let popularity: Double
    let credits: MovieCreditModel
    let videos: MovieVideosModel
    
    var posterURL: String {
        return "https://image.tmdb.org/t/p/w500\(posterPath ?? "")"
    }
}


