//
//  ImageHelper.swift
//  Hearthstone
//
//  Created by Jarede Lima on 29/03/24.
//

import UIKit

final class ImageHelper {
    static let shared = ImageHelper()
    private var cache = NSCache<NSURL, UIImage>()
    
    func image(for url: URL) -> UIImage? {
        return cache.object(forKey: url as NSURL)
    }
    
    func cache(image: UIImage, for url: URL) {
        cache.setObject(image, forKey: url as NSURL)
    }
    
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = image(for: url) {
            completion(cachedImage)
        } else {
            let task = URLSession.shared.dataTask(with: url) { [weak self] (data, _, error) in
                if let error = error {
                    print("Error loading image: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                
                guard let data = data, let downloadedImage = UIImage(data: data) else {
                    print("Error converting data to image")
                    completion(nil)
                    return
                }
                
                self?.cache(image: downloadedImage, for: url)
                completion(downloadedImage)
            }
            task.resume()
        }
    }
}
