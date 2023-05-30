//
//  ArrayMethodBlockCell.swift
//  BlockInterpreter
//
//  Created by Ivan Semenov on 25.05.2023.
//

import UIKit
import Combine

protocol ReuseIdentifier: AnyObject {
    static var reuseIdentirier: String { get set }
}

extension ReuseIdentifier {
    static var reuseIdentirier: String {
        String(describing: self)
    }
}

class ArrayMethodBlockCell: BlockCell  {

    static let identifier = "ArrayMethodBlockCel"
    
    var subscriptions = Set<AnyCancellable>()
    
    private enum Constants {
        
            enum ArrayNameTextField {
                static let insetTopBottom = 15
                static let insetLeading: CGFloat = 15
                static let multiplierWidth: CGFloat = 0.28
            }
        
            enum MethodTitleLabel {
                static let insetBottom: CGFloat = 15
            }
        
            enum OpenBracketLabel {
                static let insetLeading: CGFloat = 1
                static let insetBottom: CGFloat = 18
            }
            
            enum ValueTextField {
                static let insetTopBottom = 15
                static let insetLeading: CGFloat = 2
                static let multiplierWidth: CGFloat = 0.3
            }
            
            enum CloseBracketLabel {
                static let insetLeading: CGFloat = 2
                static let insetBottom: CGFloat = 18
            }
        
    }
    
    private let methodTitleLabel = BlockTitleLabel()
    
    private(set) var arrayNameTextField = BlockTextField()
    private(set) var valueTextField = BlockTextField()
    
    private let openBracketLabel = BlockSeparatorLabel(separatorType: .bracket(.open))
    private let closeBracketLabel = BlockSeparatorLabel(separatorType: .bracket(.close))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        subscriptions.removeAll()
        arrayNameTextField.text = nil
        valueTextField.text = nil
        valueTextField.isHidden = false
        closeBracketLabel.snp.removeConstraints()
    }
    
    func configure(with viewModel: ArrayMethodBlockCellViewModel) {
        super.configure(with: viewModel)
        
        methodTitleLabel.text = viewModel.title
        arrayNameTextField.text = viewModel.arrayName
        valueTextField.text = viewModel.value
        
        if viewModel.methodType == .pop {
            valueTextField.isHidden = true
            closeBracketLabel.snp.makeConstraints { make in
                make.leading.equalTo(openBracketLabel.snp.trailing).offset(Constants.CloseBracketLabel.insetLeading)
                make.bottom.equalToSuperview().inset(Constants.CloseBracketLabel.insetBottom)
            }
        } else {
            closeBracketLabel.snp.makeConstraints { make in
                make.leading.equalTo(valueTextField.snp.trailing).offset(Constants.CloseBracketLabel.insetLeading)
                make.bottom.equalToSuperview().inset(Constants.CloseBracketLabel.insetBottom)
            }
        }
    }
    
    private func setup() {
        setupContainerView()
        setupArrayNameTextField()
        setupMethodTitleLabel()
        setupOpenBracketLabel()
        setupCloseBracketLabel()
        setupValueTextField()
    }
    
    private func setupContainerView() {
        containerView.backgroundColor = .arrayMethodBlock
    }
    
    private func setupArrayNameTextField() {
        containerView.addSubview(arrayNameTextField)
        
        arrayNameTextField.tintColor = .arrayMethodBlock
        
        arrayNameTextField.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(Constants.ArrayNameTextField.multiplierWidth)
            make.leading.equalToSuperview().offset(Constants.ArrayNameTextField.insetLeading)
            make.top.bottom.equalToSuperview().inset(Constants.ArrayNameTextField.insetTopBottom)
        }
    }
    
    private func setupMethodTitleLabel() {
        containerView.addSubview(methodTitleLabel)

        methodTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(arrayNameTextField.snp.trailing)
            make.bottom.equalToSuperview().inset(Constants.MethodTitleLabel.insetBottom)
        }
    }
    
    private func setupOpenBracketLabel() {
        containerView.addSubview(openBracketLabel)
        
        openBracketLabel.snp.makeConstraints { make in
            make.leading.equalTo(methodTitleLabel.snp.trailing).offset(Constants.OpenBracketLabel.insetLeading)
            make.bottom.equalToSuperview().inset(Constants.OpenBracketLabel.insetBottom)
        }
    }
    
    private func setupValueTextField() {
        containerView.addSubview(valueTextField)
        
        valueTextField.tintColor = .arrayMethodBlock

        valueTextField.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(Constants.ValueTextField.multiplierWidth)
            make.leading.equalTo(openBracketLabel.snp.trailing).offset(Constants.ValueTextField.insetLeading)
            make.top.bottom.equalToSuperview().inset(Constants.ValueTextField.insetTopBottom)
        }
    }
    
    private func setupCloseBracketLabel() {
        containerView.addSubview(closeBracketLabel)
    }

}
