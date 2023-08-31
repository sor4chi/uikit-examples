//
//  CoveredImage.swift
//  21TI026-Animals
//
//  Created by 川村空千 on 2023/08/31.
//

import UIKit

class CoveredImage: UIImageView {
    let imageRatio: CGFloat = 16 / 9

    override var image: UIImage? {
        didSet {
            setNeedsLayout()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if let image = image {
            let width = frame.width
            let height = width / imageRatio
            frame.size = CGSize(width: width, height: height)
        }
    }
}

