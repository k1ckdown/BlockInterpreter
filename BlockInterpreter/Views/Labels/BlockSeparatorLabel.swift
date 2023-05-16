//
//  BlockSeparatorLabel.swift
//  BlockInterpreter
//

import UIKit

final class BlockSeparatorLabel: UILabel {
    
    init(separatorType: SeparatorType) {
        super.init(frame: .zero)
        
        setup()
        text = separatorType.title
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
