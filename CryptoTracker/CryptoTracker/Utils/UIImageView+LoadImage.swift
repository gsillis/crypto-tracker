//
//  UIImageView+LoadImage.swift
//  CryptoTracker
//
//  Created by Gabriela Sillis on 16/11/21.
//

import UIKit

struct imageCache {
    static let cache = NSCache<NSString, UIImage>()
}


extension UIImageView {

    func downloadImage(from imageString: String?) -> URLSessionDataTask? {

        guard let imageString = imageString, let url = URL(string: imageString) else {
            return nil
        }

        image = nil

        if let imageCached = imageCache.cache.object(forKey: imageString as NSString)  {
            image = imageCached
            return nil
        }

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            if let error = error {
                print(error.localizedDescription)
                return
            }

            guard let data = data,
                  let image =  UIImage(data: data)  else {
                      return
                  }

            DispatchQueue.main.async {
                self.image = image
                imageCache.cache.setObject(image, forKey: imageString as NSString)
            }
        }
        task.resume()
        return task
    }
}

