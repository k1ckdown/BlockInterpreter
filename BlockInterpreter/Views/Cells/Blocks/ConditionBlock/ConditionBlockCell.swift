//
//  ConditionBlockCell.swift
//  BlockInterpreter
//

import UIKit

final class ConditionBlockCell: BlockCell {
    
    static let identifier = "ConditionBlockCell"
    
    private enum Constants {
        
            enum ConditionTextField {
                static let multiplierWidth: CGFloat = 0.7
                static let multiplierHeight: CGFloat = 0.6
            }
            
            enum ConditionStatementLabel {
                static let insetLeading: CGFloat = 20
            }
            
            enum ConditionFieldView {
                static let insetLeading: CGFloat = 20
            }
            
            enum ThenLabel {
                static let insetLeading: CGFloat = 20
            }
        
    }
    
    private let conditionStatementLabel = UILabel()
    
    private let conditionFieldView = UIView()
    private(set) var conditionTextField = BlockTextField()
    private let thenLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with viewModel: ConditionBlockCellViewModel) {
        super.configure(with: viewModel)
        
        conditionStatementLabel.text = viewModel.conditionStatement
        conditionTextField.placeholder = viewModel.conditionTextPlaceholder
        conditionFieldView.isHidden = !viewModel.shouldShowConditionField
    }
    
    private func setup() {
        setupContainerView()
        setupConditionStatementLabel()
        setupConditionFieldView()
        setupConditionTextField()
        setupThenLabel()
    }
    
    private func setupContainerView() {
        containerView.backgroundColor = #colorLiteral(red: 0.6888309717, green: 0.7562592626, blue: 0.7880410552, alpha: 1)
    }
    
    private func setupConditionStatementLabel() {
        containerView.addSubview(conditionStatementLabel)
        
        conditionStatementLabel.textColor = .appBlack
        conditionStatementLabel.textAlignment = .left
        conditionStatementLabel.font = .conditionStatement
        conditionStatementLabel.adjustsFontSizeToFitWidth = true
        
        conditionStatementLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.ConditionStatementLabel.insetLeading)
            make.height.equalToSuperview()
        }
    }
    
    private func setupConditionFieldView() {
        containerView.addSubview(conditionFieldView)
        
        conditionFieldView.snp.makeConstraints { make in
            make.leading.equalTo(conditionStatementLabel.snp.trailing).offset(Constants.ConditionFieldView.insetLeading)
            make.trailing.height.equalToSuperview()
        }
    }
    
    private func setupConditionTextField() {
        conditionFieldView.addSubview(conditionTextField)
        
        conditionTextField.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(Constants.ConditionTextField.multiplierWidth)
            make.leading.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(Constants.ConditionTextField.multiplierHeight)
            make.centerY.equalToSuperview()
        }
    }
    
    private func setupThenLabel() {
        conditionFieldView.addSubview(thenLabel)
        
        thenLabel.text = "then"
        thenLabel.textColor = .appBlack
        thenLabel.textAlignment = .center
        thenLabel.font = .conditionStatement
        thenLabel.adjustsFontSizeToFitWidth = true
        
        thenLabel.snp.makeConstraints { make in
            make.leading.equalTo(conditionTextField.snp.trailing).offset(Constants.ThenLabel.insetLeading)
            make.height.equalToSuperview()
        }
    }
}
