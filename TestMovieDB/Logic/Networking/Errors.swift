//
//  Errors.swift
//  TestMovieDB
//
//  Created by maxim Tartachnik on 18.09.2022.
//

import Foundation

enum AppErrors: String {
    case noMovieId
    
    var code: Int {
        switch self {
        case .noMovieId:
            return -2001
        }
    }
    
    func generateError(code: Int? = nil, userInfo: [String: Any]? = nil) -> NSError {
        return NSError(
            domain: self.rawValue,
            code: code ?? self.code,
            userInfo: userInfo
        )
    }
}

enum ErrorResponse: String {
    
    case invalidEndpoint
    case invalidResponse
    case noData
    case serializationError
    
    var code: Int {
        switch self {
        case .invalidEndpoint:
            return -1001
        case .invalidResponse:
            return -1002
        case .noData:
            return -1003
        case .serializationError:
            return -1004
        }
    }
    
    func generateError(code: Int? = nil, userInfo: [String: Any]? = nil) -> NSError {
        return NSError(
            domain: self.rawValue,
            code: code ?? self.code,
            userInfo: userInfo
        )
    }
}
