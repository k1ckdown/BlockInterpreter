//
//  UIView+Gradient.swift
//  BlockInterpreter
//

import UIKit

extension UIView {
    func setGradientBackground() {
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.colors = [
            UIColor.appBlack ?? UIColor.black.cgColor,
            UIColor.appBackground?.cgColor ?? UIColor.darkGray.cgColor,
            UIColor.appGray?.cgColor ?? UIColor.gray.cgColor,
        ]
        
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = bounds
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
