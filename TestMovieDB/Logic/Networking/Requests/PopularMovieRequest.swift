//
//  PopularMovieRequest.swift
//  TestMovieDB
//
//  Created by maxim Tartachnik on 18.09.2022.
//

import Foundation

struct PopularMovieRequest: DataRequest {
    
    private let apiKey: String = "42b5d71724108693b1ecc88794b8331c"

    var url: String {
        let baseURL: String = "https://api.themoviedb.org/3"
        let path: String = "/movie/popular"
        return baseURL + path
    }
    
    var queryItems: [String : String] {
        [
            "api_key": apiKey,
            "page" : "\(page)"
        ]
    }
    
    var method: HTTPMethod = .get
    
    let page: Int
    
    init(page: Int) {
        self.page = page
    }
    
    func decode(_ data: Data) throws -> [Movie] {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        let response = try decoder.decode(MoviesResponse.self, from: data)
        return response.results
    }
}
