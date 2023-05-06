//
//  VariableBlockCell.swift
//  BlockInterpreter
//

import UIKit
import SnapKit

final class VariableBlockCell: UITableViewCell {
    
    static let identifier = "VariableBlockCell"
    
    private enum Constants {
            enum ContainerView {
                static let cornerRadius: CGFloat = 15
                static let multiplierHeight: CGFloat = 0.7
            }
            
            enum VariableTypeLabel {
                static let insetLeading: CGFloat = 15
            }
            
            enum AssignmentStackView {
                static let spacing: CGFloat = 5
                static let muiltiplierWidth: CGFloat = 0.75
                static let insetLeading: CGFloat = 20
            }
            
            enum VariableNameTextField {
                static let multiplierHeight: CGFloat = 0.7
                static let multiplierWidth: CGFloat = 0.4
            }
            
            enum EqualSignLabel {
                static let insetLeading: CGFloat = 20
                static let multiplierHeight: CGFloat = 0.4
                static let multiplierWidth: CGFloat = 0.1
            }
            
            enum VariableValueTextField {
                static let multiplierWidth: CGFloat = 0.4
                static let multiplierHeight: CGFloat = 0.7
            }
    }
    
    private let containerView = UIView()
    
    private let variableTypeLabel = UILabel()
    private let equalSignImageView = UIImageView()
    
    private let assignmentStackView = UIStackView()
    private var assignmentSVCenterXConstraint: Constraint?
    
    private(set) var variableNameTextField = BlockTextField()
    private(set) var variableValueTextField = BlockTextField()
    
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
        containerView.layer.cornerRadius = Constants.ContainerView.cornerRadius
        
        containerView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(Constants.ContainerView.multiplierHeight)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    private func setupVariableTypeLabel() {
        containerView.addSubview(variableTypeLabel)
        
        variableTypeLabel.textColor = .appTeal
        variableTypeLabel.font = .variableType
        variableTypeLabel.textAlignment = .center
        variableTypeLabel.adjustsFontSizeToFitWidth = true
        variableTypeLabel.backgroundColor = .clear
        
        variableTypeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.VariableTypeLabel.insetLeading)
            make.height.equalToSuperview()
        }
    }
    
    private func setupAssignmentStackView() {
        containerView.addSubview(assignmentStackView)
        
        assignmentStackView.spacing = Constants.AssignmentStackView.spacing
        assignmentStackView.alignment = .center
        assignmentStackView.axis = .horizontal
        assignmentStackView.distribution = .equalSpacing
        assignmentStackView.backgroundColor = .clear
        
        assignmentStackView.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(Constants.AssignmentStackView.muiltiplierWidth)
            make.leading.equalTo(variableTypeLabel.snp.trailing).offset(Constants.AssignmentStackView.insetLeading)
            assignmentSVCenterXConstraint = make.centerX.equalToSuperview().priority(.low).constraint
        }
    }
    
    private func setupVariableNameTextField() {
        assignmentStackView.addArrangedSubview(variableNameTextField)
        
        variableNameTextField.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(Constants.VariableNameTextField.multiplierHeight)
            make.width.equalToSuperview().multipliedBy(Constants.VariableNameTextField.multiplierWidth)
            make.centerY.equalToSuperview()
        }
    }
    
    private func setupEqualSignLabel() {
        assignmentStackView.addArrangedSubview(equalSignImageView)
        
        equalSignImageView.contentMode = .scaleAspectFit
        equalSignImageView.tintColor = .systemRed
        equalSignImageView.image = UIImage(systemName: "equal")
        
        equalSignImageView.snp.makeConstraints { make in
            make.leading.equalTo(variableNameTextField.snp.trailing).offset(Constants.EqualSignLabel.insetLeading)
            make.height.equalToSuperview().multipliedBy(Constants.EqualSignLabel.multiplierHeight)
            make.width.equalToSuperview().multipliedBy(Constants.EqualSignLabel.multiplierWidth)
        }
    }
    
    private func setupVariableValueTextField() {
        assignmentStackView.addArrangedSubview(variableValueTextField)
        
        variableValueTextField.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(Constants.VariableValueTextField.multiplierWidth)
            make.height.equalToSuperview().multipliedBy(Constants.VariableValueTextField.multiplierHeight)
            make.centerY.equalToSuperview()
        }
    }

}
