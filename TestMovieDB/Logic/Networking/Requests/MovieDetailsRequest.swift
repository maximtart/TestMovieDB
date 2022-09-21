//
//  MovieDetailsRequest.swift
//  TestMovieDB
//
//  Created by maxim Tartachnik on 19.09.2022.
//

import Foundation

struct MovieDetailsRequest: DataRequest {
    
    private let apiKey: String = "42b5d71724108693b1ecc88794b8331c"

    var url: String {
        let baseURL: String = "https://api.themoviedb.org/3"
        let path: String = "/movie/\(movieId)"
        return baseURL + path
    }
    
    var queryItems: [String : String] {
        [
            "api_key": apiKey,
            "append_to_response" : "credits,videos"
        ]
    }
    
    var method: HTTPMethod = .get
    
    let movieId: Int
    
    init(movieId: Int) {
        self.movieId = movieId
    }
    
    func decode(_ data: Data) throws -> MovieDetailsResponse {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        let response = try decoder.decode(MovieDetailsResponse.self, from: data)
        return response
    }
}
