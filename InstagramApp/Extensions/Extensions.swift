//
//  Extensions.swift
//  InstagramApp
//
//  Created by Takasur A. on 02/12/2021.
//  Copyright © 2021 Gwinyai Nyatsoka. All rights reserved.
//

import UIKit

extension UIViewController {

    class func displayLoading(withView: UIView) -> UIView {
        let spinnerView = UIView(frame: withView.bounds)
        spinnerView.backgroundColor = .clear
        var ai: UIActivityIndicatorView!
        if #available(iOS 13.0, *) {
            ai = UIActivityIndicatorView(style: .large)
        } else {
            ai = UIActivityIndicatorView(style: .gray)
        }
        ai.startAnimating()
        ai.center = spinnerView.center
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            withView.addSubview(spinnerView)
        }
        return spinnerView
    }

    class func removeFromLoading(spinner: UIView) {
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }
}

extension UIImage {
    func resized(toWidth width: CGFloat) -> UIImage? {
        if self.size.width <= width {
            return self
        }
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width * size.height) / size.width))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
