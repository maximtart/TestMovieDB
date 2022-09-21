//
//  MoviesResponse.swift
//  TestMovieDB
//
//  Created by maxim Tartachnik on 18.09.2022.
//

import UIKit

struct MoviesResponse: Codable {
    let page: Int
    let totalResults: Int
    let totalPages: Int
    let results: [Movie]
}

struct Movie: Codable {
    let id: Int
    let title: String
    let posterPath: String?
    let voteAverage: Double
    let releaseDate: Date
    
    var posterURL: String {
        return "https://image.tmdb.org/t/p/w500\(posterPath ?? "")"
    }
}
