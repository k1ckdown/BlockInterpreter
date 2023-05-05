//
//  VariableBlockCell.swift
//  BlockInterpreter
//
//  Created by Ivan Semenov on 04.05.2023.
//

import UIKit
import SnapKit

final class VariableBlockCell: UITableViewCell {
    
    static let identifier = "VariableBlockCell"
    
    private let containerView = UIView()
    
    private let variableTypeLabel = UILabel()
    private let equalSignImageView = UIImageView()
    
    private let assignmentStackView = UIStackView()
    private var assignmentSVCenterXConstraint: Constraint?
    
    private(set) var variableNameTextField = UITextField()
    private(set) var variableValueTextField = UITextField()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with viewModel: VariableBlockCellViewModel) {
        variableTypeLabel.text = viewModel.variableType
        variableNameTextField.placeholder = viewModel.variableNamePlaceHolder
        variableValueTextField.placeholder = viewModel.variableValuePlaceholder
        
        guard viewModel.shouldShowVariableType == false else { return }
        variableTypeLabel.isHidden = true
        assignmentSVCenterXConstraint?.update(priority: .high)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        variableTypeLabel.isHidden = false
        assignmentSVCenterXConstraint?.update(priority: .low)
    }
    
    private func setup() {
        setupSuperView()
        setupContainerView()
        setupVariableTypeLabel()
        setupAssignmentStackView()
        setupVariableNameTextField()
        setupEqualSignLabel()
        setupVariableValueTextField()
    }
    
    private func setupSuperView() {
        backgroundColor = .clear
    }
    
    private func setupContainerView() {
        contentView.addSubview(containerView)
        
        containerView.backgroundColor = .appBlack
        containerView.layer.cornerRadius = 10
        
        containerView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.7)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    private func setupVariableTypeLabel() {
        containerView.addSubview(variableTypeLabel)
        
        variableTypeLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        variableTypeLabel.textAlignment = .center
        variableTypeLabel.adjustsFontSizeToFitWidth = true
        variableTypeLabel.textColor = .systemTeal
        variableTypeLabel.backgroundColor = .clear
        
        variableTypeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.height.equalToSuperview()
        }
    }
    
    private func setupAssignmentStackView() {
        containerView.addSubview(assignmentStackView)
        
        assignmentStackView.spacing = 5
        assignmentStackView.alignment = .center
        assignmentStackView.axis = .horizontal
        assignmentStackView.distribution = .equalSpacing
        assignmentStackView.backgroundColor = .clear
        
        assignmentStackView.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.75)
            make.leading.equalTo(variableTypeLabel.snp.trailing).offset(20)
            assignmentSVCenterXConstraint = make.centerX.equalToSuperview().priority(.low).constraint
        }
    }
    
    private func setupVariableNameTextField() {
        assignmentStackView.addArrangedSubview(variableNameTextField)
        
        variableNameTextField.textAlignment = .center
        variableNameTextField.borderStyle = .none
        variableTypeLabel.font = UIFont.systemFont(ofSize: 17)
        variableNameTextField.adjustsFontSizeToFitWidth = true
        variableNameTextField.clearButtonMode = .never
        variableNameTextField.returnKeyType = .done
        variableNameTextField.textColor = .appBlack
        variableNameTextField.backgroundColor = .appWhite
        variableNameTextField.layer.cornerRadius = 10
        
        variableNameTextField.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.7)
            make.width.equalToSuperview().multipliedBy(0.4)
            make.centerY.equalToSuperview()
        }
    }
    
    private func setupEqualSignLabel() {
        assignmentStackView.addArrangedSubview(equalSignImageView)
        
        equalSignImageView.contentMode = .scaleAspectFit
        equalSignImageView.tintColor = .systemRed
        equalSignImageView.image = UIImage(systemName: "equal")
        
        equalSignImageView.snp.makeConstraints { make in
            make.leading.equalTo(variableNameTextField.snp.trailing).offset(20)
            make.height.equalToSuperview().multipliedBy(0.4)
            make.width.equalToSuperview().multipliedBy(0.1)
        }
    }
    
    private func setupVariableValueTextField() {
        assignmentStackView.addArrangedSubview(variableValueTextField)
        
        variableValueTextField.font = UIFont.systemFont(ofSize: 17)
        variableValueTextField.borderStyle = .none
        variableValueTextField.adjustsFontSizeToFitWidth = true
        variableValueTextField.returnKeyType = .done
        variableValueTextField.textAlignment = .center
        variableValueTextField.clearButtonMode = .never
        variableValueTextField.textColor = .appBlack
        variableValueTextField.backgroundColor = .appWhite
        variableValueTextField.layer.cornerRadius = 10
        
        variableValueTextField.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.4)
            make.height.equalToSuperview().multipliedBy(0.7)
            make.centerY.equalToSuperview()
        }
    }

}
