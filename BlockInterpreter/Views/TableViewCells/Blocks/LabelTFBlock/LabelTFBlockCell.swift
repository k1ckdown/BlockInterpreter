//
//  LabelTFBlockBlockCell.swift
//  BlockInterpreter
//

import UIKit

class LabelTFBlockCell: BlockCell {
    
    private enum Constants {
        
            enum Label {
                static let insetLeading: CGFloat = 15
            }
        
            enum TextField {
                static let insetTrailing: CGFloat = -7
                static let insetTopBottom: CGFloat = 12
                static let multiplierWidth: CGFloat = 0.6
            }
        
    }
    
    var labelTitle: String? {
        didSet {
            label.text = labelTitle
        }
    }
    
    var textFieldText: String? {
        didSet {
            textField.text = textFieldText
        }
    }
    
    var textFieldPlaceholder: String? {
        didSet {
            textField.placeholder = textFieldPlaceholder
        }
    }
    
    private(set) var label = BlockTitleLabel()
    private(set) var textField = BlockTextField()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textField.text = nil
    }
    
    private func setup() {
        setupTextField()
        setupLabel()
    }
    
    private func setupTextField() {
        containerView.addSubview(textField)
        
        textField.tintColor = .clear
        
        textField.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(Constants.TextField.insetTopBottom)
            make.width.equalToSuperview().multipliedBy(Constants.TextField.multiplierWidth)
            make.trailing.equalToSuperview().offset(Constants.TextField.insetTrailing)
        }
    }
    
    private func setupLabel() {
        containerView.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(Constants.Label.insetLeading)
        }
    }

}
