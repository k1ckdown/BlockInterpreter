//
//  VariableBlockCell.swift
//  BlockInterpreter
//

import UIKit
import SnapKit
import Combine

final class VariableBlockCell: BlockCell {
    
    static let identifier = "VariableBlockCell"
    
    var subscriptions = Set<AnyCancellable>()
    
    private enum Constants {
            
            enum VariableTypeLabel {
                static let insetLeading: CGFloat = 20
            }
            
            enum AssignmentStackView {
                static let spacing: CGFloat = 5
                static let muiltiplierWidth: CGFloat = 0.75
                static let insetLeading: CGFloat = 15
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
    
    private let variableTypeLabel = BlockTitleLabel()
    private let equalSignImageView = UIImageView()
    
    private let assignmentStackView = UIStackView()
    
    private(set) var variableNameTextField = BlockTextField()
    private(set) var variableValueTextField = BlockTextField()
    
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
        variableTypeLabel.isHidden = false
        assignmentStackView.snp.removeConstraints()
        
        variableNameTextField.text = nil
        variableValueTextField.text = nil
    }
    
    func configure(with viewModel: VariableBlockCellViewModel) {
        super.configure(with: viewModel)
        
        variableNameTextField.text = viewModel.variableName
        variableValueTextField.text = viewModel.variableValue
        variableTypeLabel.text = viewModel.variableType?.rawValue.capitalized

        variableNameTextField.placeholder = viewModel.variableNamePlaceHolder
        variableValueTextField.placeholder = viewModel.variableValuePlaceholder
        
        assignmentStackView.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(Constants.AssignmentStackView.muiltiplierWidth)
        }
        
        if viewModel.shouldShowVariableType == true {
            assignmentStackView.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
                make.leading.equalTo(variableTypeLabel.snp.trailing).offset(Constants.AssignmentStackView.insetLeading)
            }
        } else {
            variableTypeLabel.isHidden = true
            assignmentStackView.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview()
            }
        }
    }
    
    private func setup() {
        setupContainerView()
        setupVariableTypeLabel()
        setupAssignmentStackView()
        setupVariableNameTextField()
        setupEqualSignImageView()
        setupVariableValueTextField()
    }
    
    private func setupContainerView() {
        containerView.backgroundColor = .variableBlock
    }
    
    private func setupVariableTypeLabel() {
        containerView.addSubview(variableTypeLabel)
        
        variableTypeLabel.textColor = .appBlack
        variableTypeLabel.font = .blockTitle
        variableTypeLabel.textAlignment = .center
        variableTypeLabel.backgroundColor = .clear
        
        variableTypeLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(Constants.VariableTypeLabel.insetLeading)
        }
    }
    
    private func setupAssignmentStackView() {
        containerView.addSubview(assignmentStackView)
        
        assignmentStackView.spacing = Constants.AssignmentStackView.spacing
        assignmentStackView.alignment = .center
        assignmentStackView.axis = .horizontal
        assignmentStackView.distribution = .equalSpacing
        assignmentStackView.backgroundColor = .clear
    }
    
    private func setupVariableNameTextField() {
        assignmentStackView.addArrangedSubview(variableNameTextField)
        
        variableNameTextField.tintColor = .variableBlock
        
        variableNameTextField.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(Constants.VariableNameTextField.multiplierHeight)
            make.width.equalToSuperview().multipliedBy(Constants.VariableNameTextField.multiplierWidth)
        }
    }
    
    private func setupEqualSignImageView() {
        assignmentStackView.addArrangedSubview(equalSignImageView)
        
        equalSignImageView.contentMode = .scaleAspectFit
        equalSignImageView.tintColor = .appBlack
        equalSignImageView.image = UIImage(systemName: "equal")
        
        equalSignImageView.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(Constants.EqualSignLabel.multiplierHeight)
            make.width.equalToSuperview().multipliedBy(Constants.EqualSignLabel.multiplierWidth)
        }
    }
    
    private func setupVariableValueTextField() {
        assignmentStackView.addArrangedSubview(variableValueTextField)
        
        variableValueTextField.tintColor = .variableBlock
        
        variableValueTextField.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(Constants.VariableValueTextField.multiplierWidth)
            make.height.equalToSuperview().multipliedBy(Constants.VariableValueTextField.multiplierHeight)
        }
    }

}
