//
//  ImageDownloader.swift
//  RickAndMorty
//
//  Created by Dio Putra Utama on 03/04/25.
//

import Foundation
import UIKit

internal class ImageDownloader {
    private let cache = NSCache<NSString, UIImage>()

    func downloadImageWithCache(url: URL) async -> UIImage? {
        let cacheKey = url.absoluteString as NSString

        if let cachedImage = cache.object(forKey: cacheKey) {
            return cachedImage
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let image = UIImage(data: data) {
                cache.setObject(image, forKey: cacheKey)
                return image
            }
        } catch {
            print("Download error: \(error)")
            return nil
        }

        return nil
    }
}
