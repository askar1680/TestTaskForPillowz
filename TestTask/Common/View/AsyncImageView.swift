//
//  AsyncImageView.swift
//  TestTask
//
//  Created by Аскар on 5/14/19.
//  Copyright © 2019 askar.ulubayev. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

class AsyncImageView: UIImageView {
    
    private var currentUrl: String?
    
    public func downloadImageFrom(urlString: String) {
        currentUrl = urlString
        
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage{
            self.image = cachedImage
            return
        }
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        guard let url = URL(string: urlString) else { return }
        let task = session.dataTask(with: url, completionHandler: { (data, response, error) -> Void in
            guard error == nil else {
                print(error?.localizedDescription as Any)
                return
            }
            guard let data = data, let downloadedImage = UIImage(data: data) else { return }
            guard urlString == self.currentUrl else { return }
            imageCache.setObject(downloadedImage as AnyObject, forKey: urlString as AnyObject)
            DispatchQueue.main.async {
                self.alpha = 0
                self.image = downloadedImage
                UIView.animate(withDuration: 0.5, animations: {
                    self.alpha = 1
                })
            }
        })
        task.resume()
    }
    
}
