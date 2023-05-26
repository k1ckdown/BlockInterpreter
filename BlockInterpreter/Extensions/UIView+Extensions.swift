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
    
    func takeScreenshot() -> UIImage? {
        let originalFrame = frame
        let originalContentMode = contentMode
        
        guard let scrollView = self as? UIScrollView else {
            UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
            drawHierarchy(in: bounds, afterScreenUpdates: true)
            let screenshot = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return screenshot
        }

        let savedContentOffset = scrollView.contentOffset
        let savedFrame = scrollView.frame
        scrollView.contentOffset = .zero
        scrollView.frame = CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height)

        UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, false, UIScreen.main.scale)
        guard let currentContext = UIGraphicsGetCurrentContext() else { return nil }
        scrollView.layer.render(in: currentContext)

        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        scrollView.contentOffset = savedContentOffset
        scrollView.frame = savedFrame
        frame = originalFrame
        contentMode = originalContentMode

        return screenshot
    }
}
