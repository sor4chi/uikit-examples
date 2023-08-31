//
//  URLImageView.swift
//  21TI026-Animals
//
//  Created by 川村空千 on 2023/08/31.
//

import UIKit

class URLImageView: UIImageView {
    private var imageLoadingTask: URLSessionDataTask?
    private var skeletonLayer: CALayer?

    var imageURL: URL? {
        didSet {
            loadImage()
        }
    }

    private func loadImage() {
        imageLoadingTask?.cancel()

        // Skeleton表示
        showSkeleton()

        if let url = imageURL {
            imageLoadingTask = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        // Skeleton非表示
                        self?.hideSkeleton()

                        self?.image = image
                    }
                }
            }
            imageLoadingTask?.resume()
        }
    }

    private func showSkeleton() {
        // アニメーションの設定
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 0.5
        animation.toValue = 1
        animation.duration = 0.5
        animation.repeatCount = .infinity
        animation.autoreverses = true

        // Skeletonの設定
        let skeletonLayer = CALayer()
        skeletonLayer.backgroundColor = UIColor.lightGray.cgColor
        skeletonLayer.frame = bounds
        skeletonLayer.add(animation, forKey: "opacity")
        layer.addSublayer(skeletonLayer)
        self.skeletonLayer = skeletonLayer
    }

    private func hideSkeleton() {
        skeletonLayer?.removeFromSuperlayer()
        skeletonLayer = nil
    }
}

