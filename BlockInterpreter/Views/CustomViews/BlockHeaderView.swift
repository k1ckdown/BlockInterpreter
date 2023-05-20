//
//  BlockHeaderView.swift
//  BlockInterpreter
//

import UIKit

final class BlockHeaderView: UIView {
    
    var headerTitle: String? {
        didSet {
            headerTitleLabel.text = headerTitle
        }
    }
    
    private enum Constants {
            enum SuperView {
                static let cornerRadius: CGFloat = 8
                static let borderWidth: CGFloat = 0.3
            }
        
            enum HeaderTitleLabel {
                static let insetLeading: CGFloat = 20
                static let insetTopBottom: CGFloat = 4
            }
    }
    
    private let headerTitleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        setupSuperView()
        setupHeaderTitleLabel()
    }
    
    private func setupSuperView() {
        backgroundColor = .blockBorder
        layer.cornerRadius = Constants.SuperView.cornerRadius
    }
    
    private func setupHeaderTitleLabel() {
        addSubview(headerTitleLabel)
        
        headerTitleLabel.font = .blockHeader
        headerTitleLabel.textAlignment = .left
        headerTitleLabel.textColor = .appWhite
        
        headerTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.HeaderTitleLabel.insetLeading)
            make.top.bottom.equalToSuperview().inset(Constants.HeaderTitleLabel.insetTopBottom)
        }
    }
}
