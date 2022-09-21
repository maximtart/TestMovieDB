//
//  ImageRequest.swift
//  TestMovieDB
//
//  Created by maxim Tartachnik on 18.09.2022.
//

import UIKit

struct ImageRequest: DataRequest {
    
    let url: String
    
    var method: HTTPMethod = .get
    
    func decode(_ data: Data) throws -> UIImage {
        guard let image = UIImage(data: data) else {
            throw NSError(
                domain: ErrorResponse.invalidResponse.rawValue,
                code: 13,
                userInfo: nil
            )
        }
        
        return image
    }
}
