//
//  LabelTFBlockBlockCell.swift
//  BlockInterpreter
//

import UIKit

class LabelTFBlockCell: BlockCell {
    
    private enum Constants {
        
            enum Label {
                static let insetLeading: CGFloat = 22
            }
        
            enum TextField {
                static let insetTrailing: CGFloat = 22
                static let insetTopBottom: CGFloat = 12
                static let multiplierWidth: CGFloat = 0.6
            }
        
    }
    
    private let label = UILabel()
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
    
    func configure(with viewModel: LabelTFBlockCellViewModel) {
        super.configure(with: viewModel)
        
        label.text = viewModel.title
        textField.text = viewModel.text
        textField.placeholder = viewModel.placeholder
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
            make.trailing.equalToSuperview().inset(Constants.TextField.insetTrailing)
        }
    }
    
    private func setupLabel() {
        containerView.addSubview(label)
        
        label.font = .blockTitle
        label.textColor = .appBlack
        label.textAlignment = .center
        
        label.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(Constants.Label.insetLeading)
        }
    }

}
