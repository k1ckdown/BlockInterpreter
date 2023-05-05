//
//  BlockHeaderView.swift
//  BlockInterpreter
//
//  Created by Ivan Semenov on 06.05.2023.
//

import UIKit

class BlockHeaderView: UIView {
    
    private let headerTitleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var headerTitle: String? {
        didSet {
            headerTitleLabel.text = headerTitle
        }
    }

    private func setup() {
        setupSuperView()
        setupHeaderTitleLabel()
    }
    
    private func setupSuperView() {
        backgroundColor = .appWhite
        layer.cornerRadius = 8
    }
    
    private func setupHeaderTitleLabel() {
        addSubview(headerTitleLabel)
        
        headerTitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        headerTitleLabel.textAlignment = .left
        headerTitleLabel.textColor = .appBlack
        headerTitleLabel.backgroundColor = .clear
        
        headerTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.bottom.equalToSuperview().inset(4)
        }
    }
}
