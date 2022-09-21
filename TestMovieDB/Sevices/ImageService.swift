//
//  ImageService.swift
//  TestMovieDB
//
//  Created by maxim Tartachnik on 18.09.2022.
//

import UIKit

protocol ImageServiceProtocol {
    func downloadImage<Request: DataRequest>(request: Request, completion: @escaping (UIImage?, Error?) -> Void)
    func setImage(from url: String, completion: @escaping (UIImage?) -> Void)
}

final class ImageService {
    
    static let shared = ImageService(
        responseQueue: .main,
        session: URLSession.shared
    )
    
    private(set) var cachedImages: [String]
    
    let responseQueue: DispatchQueue?
    let session: URLSession
    
    init(responseQueue: DispatchQueue?, session: URLSession) {
        
        
        self.responseQueue = responseQueue
        self.session = session
        
        
        let fileManager = FileManager.default
        guard let path = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first
        else {
            self.cachedImages = []
            return
        }
        
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: path, includingPropertiesForKeys: nil)
            self.cachedImages = fileURLs.map { $0.path() }
        } catch {
            print("Error while enumerating files \(path.path): \(error.localizedDescription)")
            self.cachedImages = []
        }
        
    }
    
    private func dispatchImage(
        image: UIImage? = nil,
        error: Error? = nil,
        completion: @escaping (UIImage?, Error?
        ) -> Void) {
        
        guard let responseQueue = responseQueue else {
            completion(image, error)
            return
        }
        
        responseQueue.async {
            completion(image, error)
        }
    }
}

extension ImageService: ImageServiceProtocol {
    func downloadImage<Request: DataRequest>(request: Request, completion: @escaping (UIImage?, Error?) -> Void) {
        
        let service: NetworkServiceProtocol = NetworkService()
        
        service.request(request) { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(let response):
                guard let image: UIImage = response as? UIImage else {
                    return
                }
                
                self.dispatchImage(image: image, completion: completion)
            case .failure(let error):
                self.dispatchImage(error: error, completion: completion)
            }
        }
    }
    
    
    
    func setImage(from url: String, completion: @escaping (UIImage?) -> Void) {
        let request = ImageRequest(url: url)
        guard let link = URL(string: url) else {
            print("Cant create link")
            return
        }
        
        if let cachePath = (cachedImages.first { $0.contains(link.lastPathComponent) }) {
            DispatchQueue.main.async {
                completion(UIImage(contentsOfFile: cachePath))
            }
        } else {
            downloadImage(request: request) { [weak self] image, error in
                guard let self = self else {
                    return
                }
                
                guard let image = image else {
                    print(error?.localizedDescription ?? "No Description")
                    return
                }
                
                guard let path = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
                    print("Cant find cache directory")
                    return
                }
                
                guard let data = image.jpegData(compressionQuality: 0.8) else {
                    print("Cant get image data")
                    return
                }
                
                DispatchQueue.main.async {
                    let filename = path.appendingPathComponent(link.lastPathComponent)
                    
                    try? data.write(to: filename)
                    self.cachedImages.append(filename.path())
                    completion(image)
                }
            }
        }
    }
}
