//
//  Extensions.swift
//  MacroCHallengeApp
//
//  Created by João Pedro de Amorim on 07/10/20.
//

import Foundation
import UIKit

extension UITabBarController {
    open override var childForStatusBarStyle: UIViewController? {
        return selectedViewController?.childForStatusBarStyle ?? selectedViewController
    }
}

extension UINavigationController {
    open override var childForStatusBarStyle: UIViewController? {
        return topViewController?.childForStatusBarStyle ?? topViewController
    }
}

let imageCache = NSCache<NSString, UIImage>()
extension UIImageView {
	// to download image with link
	func loadImageUsingCache(withUrl urlString : String) {
		let url = URL(string: urlString)
		if url == nil {return}
		self.image = nil

		// check cached image
		if let cachedImage = imageCache.object(forKey: urlString as NSString)  {
			self.image = cachedImage
			return
		}

		let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView.init(style: .medium)
		addSubview(activityIndicator)
		activityIndicator.startAnimating()
		activityIndicator.center = self.center

		// if not, download image from url
		URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
			if error != nil {
				print(error!)
				return
			}

			DispatchQueue.main.async {
				if let image = UIImage(data: data!) {
					imageCache.setObject(image, forKey: urlString as NSString)
					self.image = image
					activityIndicator.removeFromSuperview()
				}
			}

		}).resume()
	}
}

