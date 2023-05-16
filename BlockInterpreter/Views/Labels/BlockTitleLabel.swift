//
//  BlockTitleLabel.swift
//  BlockInterpreter
//

import UIKit

final class BlockTitleLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        font = .blockTitle
        textColor = .appBlack
        textAlignment = .center
    }
}
