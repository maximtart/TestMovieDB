//
//  MovieVideosModel.swift
//  TestMovieDB
//
//  Created by maxim Tartachnik on 19.09.2022.
//

import Foundation

struct MovieVideosModel: Codable {
    let results: [MovieVideo]
}

struct MovieVideo: Codable {
    let id: String
    let key: String
    let name: String
    let site: SiteKind
    let size: Int
    let type: String
    
    var youtubeURL: URL? {
        guard site == .youtube else {
            return nil
        }
        return URL(string: "https://www.youtube.com/watch?v=\(key)")
    }
}

extension MovieVideo {
    enum SiteKind: Codable, Equatable {
        case youtube
        case other(String)
        
        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let site = try? container.decode(String.self)
            switch site?.lowercased() {
            case "youtube": self = .youtube
            default:
                self = .other(site ?? "unknown")
            }
        }
    }
}
