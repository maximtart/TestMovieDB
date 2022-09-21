//
//  MovieCreditModel.swift
//  TestMovieDB
//
//  Created by maxim Tartachnik on 19.09.2022.
//

import Foundation

struct MovieCreditModel: Codable {
    let cast: [MovieCast]
    let crew: [MovieCrew]
}

struct MovieCast: Codable {
    let character: String
    let name: String
    let profilePath: String?
    
    var avatarURL: String {
        return "https://image.tmdb.org/t/p/w500\(profilePath ?? "")"
    }
}

struct MovieCrew: Codable {
    let id: Int
    let department: String
    let job: JobKind
    let name: String
}

extension MovieCrew {
    enum JobKind: Codable, Equatable {
        case director
        case other(String)
        
        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let job = try? container.decode(String.self)
            switch job?.lowercased() {
            case "director": self = .director
            default:
                self = .other(job ?? "unknown")
            }
        }
    }
}
