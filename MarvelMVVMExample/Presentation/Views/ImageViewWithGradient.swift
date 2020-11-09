//
//  ImageViewWithGradient.swift
//  MarvelMVVMExample
//
//  Created by Ivan F Garcia S on 09/11/20.
//  Copyright © 2020 Ivan F Garcia S. All rights reserved.
//

import UIKit
import AVFoundation

class ImageViewWithGradient: UIImageView {
    
    // MARK: - Variables and constants
    
    var edgeColor: UIColor = .clear
    var centerColor: UIColor = .black
    
    let gradientLayer: CAGradientLayer = CAGradientLayer()
    
    struct Constants {
        static let initialPoint: CGFloat = 0
        static let verticalStartPoint: CGFloat = 0.5
        static let verticalEndPoint: CGFloat = 1
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    class func initWithFrame(_ frame: CGRect, edgeColor: UIColor, centerColor: UIColor) -> ImageViewWithGradient {
        let imageViewWithGradient = ImageViewWithGradient(frame: frame)
        imageViewWithGradient.edgeColor = edgeColor
        imageViewWithGradient.centerColor = centerColor
        imageViewWithGradient.setup()
        return imageViewWithGradient
    }
    
    func setup() {
        gradientLayer.startPoint = CGPoint(x: Constants.initialPoint, y: Constants.verticalStartPoint)
        gradientLayer.endPoint = CGPoint(x: Constants.initialPoint, y: Constants.verticalEndPoint)
        let colors: [CGColor] = [
            edgeColor.cgColor,
            centerColor.cgColor,
            edgeColor.cgColor
        ]
        gradientLayer.colors = colors
        gradientLayer.isOpaque = false
        gradientLayer.locations = [0.0, 1.0]
        layer.addSublayer(gradientLayer)
    }
    
    override func layoutSubviews() {
        gradientLayer.frame = layer.bounds
    }
}
