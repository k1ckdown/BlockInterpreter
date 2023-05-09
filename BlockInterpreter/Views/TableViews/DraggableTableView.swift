//
//  DraggableTableView.swift
//  BlockInterpreter
//

import UIKit

class DraggableTableView: UITableView {

    override public func didAddSubview(_ subview: UIView) {
        super.didAddSubview(subview)

        if "\(type(of: subview))" == "_UIPlatterView" {
            subview.subviews.forEach({ $0.removeFromSuperview() })
        }
        
        if "\(type(of: subview))" == "UIShadowView" {
                subview.isHidden = true
            }
    }

}
