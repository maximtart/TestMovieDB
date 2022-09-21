//
//  NetworkService.swift
//  TestMovieDB
//
//  Created by maxim Tartachnik on 18.09.2022.
//

import Foundation

protocol NetworkServiceProtocol {
    func request<Request: DataRequest>(_ request: Request, completion: @escaping (Result<Request.Response, Error>) -> Void)
}

final class NetworkService: NetworkServiceProtocol {
    
    func request<Request: DataRequest>(_ request: Request, completion: @escaping (Result<Request.Response, Error>) -> Void) {
        
        guard var urlComponent = URLComponents(string: request.url) else {
            let error = NSError(
                domain: ErrorResponse.invalidEndpoint.rawValue,
                code: 404,
                userInfo: nil
            )
            
            return completion(.failure(error))
        }
        
        var queryItems: [URLQueryItem] = []
        
        request.queryItems.forEach {
            let urlQueryItem = URLQueryItem(name: $0.key, value: $0.value)
            urlComponent.queryItems?.append(urlQueryItem)
            queryItems.append(urlQueryItem)
        }
        
        urlComponent.queryItems = queryItems
        
        guard let url = urlComponent.url else {
            let error = NSError(
                domain: ErrorResponse.invalidEndpoint.rawValue,
                code: 404,
                userInfo: nil
            )
            
            return completion(.failure(error))
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.allHTTPHeaderFields = request.headers
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            
            func callback(_ result: Result<Request.Response, Error>) {
                DispatchQueue.main.async {
                    completion(result)
                }
            }
            
            if let error = error {
                return callback(.failure(error))
            }
            
            guard let response = response as? HTTPURLResponse,
                    200..<300 ~= response.statusCode else {
                
                let code = (response as? HTTPURLResponse)?.statusCode
                return callback(.failure(
                    ErrorResponse.invalidResponse.generateError(code: code)
                ))
            }
            
            guard let data = data else {
                return callback(.failure(
                    ErrorResponse.noData.generateError()
                ))
            }
            
            do {
                try callback(.success(request.decode(data)))
            } catch let error as NSError {
                callback(.failure(error))
            }
        }
        .resume()
    }
}
