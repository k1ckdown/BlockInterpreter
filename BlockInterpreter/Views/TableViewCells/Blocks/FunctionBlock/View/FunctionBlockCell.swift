//
//  FunctionBlockCell.swift
//  BlockInterpreter
//

import UIKit
import Combine

final class FunctionBlockCell: BlockCell {
    
    var subscriptions = Set<AnyCancellable>()
    
    private enum Constants {
        
            enum BlockTitleLabel {
                static let insetLeading: CGFloat = 15
            }
            
            enum FunctionNameTextField {
                static let insetLeading: CGFloat = 7
                static let insetTopBottom: CGFloat = 17
                static let multiplierWidth: CGFloat = 0.16
            }
            
            enum OpenBracketLabel {
                static let insetLeading: CGFloat = 2
            }
            
            enum ArgumentsTextField {
                static let insetLeading: CGFloat = 2
                static let insetTopBottom: CGFloat = 17
                static let multiplierWidth: CGFloat = 0.22
            }
            
            enum CloseBracketLabel {
                static let insetLeading: CGFloat = 2
            }
            
            enum ArrowImageView {
                static let insetLeading: CGFloat = 2
            }
            
            enum ReturnTypeButton {
                static let insetLeading: CGFloat = 2
            }
        
    }

    private let blockTitleLabel = BlockTitleLabel()
    private let returnTypeButton = VariableTypeButton()
    private lazy var arrowImageView = UIImageView()
    
    private(set) var argumentsTextField = BlockTextField()
    private(set) var functionNameTextField = BlockTextField()
    
    private let openBracketLabel = BlockSeparatorLabel(separatorType: .bracket(.open))
    private let closeBracketLabel = BlockSeparatorLabel(separatorType: .bracket(.close))
    
    private var viewModel: FunctionBlockCellViewModel? {
        didSet {
            setupBindings()
        }
    }
    
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
        argumentsTextField.text = nil
        functionNameTextField.text = nil
    }
    
    func configure(with viewModel: FunctionBlockCellViewModel) {
        super.configure(with: viewModel)
        
        self.viewModel = viewModel
        blockTitleLabel.text = viewModel.title
        returnTypeButton.title = viewModel.typeTitle
        argumentsTextField.text = viewModel.argumentsString
        functionNameTextField.text = viewModel.functionName
    }
    
    private func updateAppearanceTypeButton() {
        UIView.transition(
            with: returnTypeButton,
            duration: 0.4,
            options: [.transitionFlipFromRight]
        ) {
            self.returnTypeButton.title = self.viewModel?.typeTitle
        }
    }

    
    private func setup() {
        setupContainerView()
        setupBlockTitleLabel()
        setupFunctionNameTextField()
        setupOpenBracketLabel()
        setupArgumentsTextField()
        setupCloseBracketLabel()
        setupArrowImageView()
        setupReturnTypeButton()
    }
    
    private func setupContainerView() {
        containerView.backgroundColor = .functionBlock
    }
    
    private func setupBlockTitleLabel() {
        containerView.addSubview(blockTitleLabel)
        
        blockTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.BlockTitleLabel.insetLeading)
            make.centerY.equalToSuperview()
        }
    }
    
    private func setupFunctionNameTextField() {
        containerView.addSubview(functionNameTextField)
        
        functionNameTextField.snp.makeConstraints { make in
            make.leading.equalTo(blockTitleLabel.snp.trailing).offset(Constants.FunctionNameTextField.insetLeading)
            make.top.bottom.equalToSuperview().inset(Constants.FunctionNameTextField.insetTopBottom)
            make.width.equalToSuperview().multipliedBy(Constants.FunctionNameTextField.multiplierWidth)
        }
    }
    
    private func setupOpenBracketLabel() {
        containerView.addSubview(openBracketLabel)
        
        openBracketLabel.snp.makeConstraints { make in
            make.leading.equalTo(functionNameTextField.snp.trailing).offset(Constants.OpenBracketLabel.insetLeading)
            make.centerY.equalToSuperview()
        }
    }
    
    private func setupArgumentsTextField() {
        containerView.addSubview(argumentsTextField)
        
        argumentsTextField.snp.makeConstraints { make in
            make.leading.equalTo(openBracketLabel.snp.trailing).offset(Constants.ArgumentsTextField.insetLeading)
            make.top.bottom.equalToSuperview().inset(Constants.ArgumentsTextField.insetTopBottom)
            make.width.equalToSuperview().multipliedBy(Constants.ArgumentsTextField.multiplierWidth)
        }
    }
    
    private func setupCloseBracketLabel() {
        containerView.addSubview(closeBracketLabel)
        
        closeBracketLabel.snp.makeConstraints { make in
            make.leading.equalTo(argumentsTextField.snp.trailing).offset(Constants.CloseBracketLabel.insetLeading)
            make.centerY.equalToSuperview()
        }
    }
    
    private func setupArrowImageView() {
        containerView.addSubview(arrowImageView)
        
        arrowImageView.tintColor = .appBlack
        arrowImageView.contentMode = .scaleAspectFit
        arrowImageView.image = UIImage(systemName: "arrow.right")
        
        arrowImageView.snp.makeConstraints { make in
            make.leading.equalTo(closeBracketLabel.snp.trailing).offset(Constants.ArrowImageView.insetLeading)
            make.top.bottom.equalToSuperview()
        }
    }
    
    private func setupReturnTypeButton() {
        containerView.addSubview(returnTypeButton)
        
        returnTypeButton.snp.makeConstraints { make in
            make.width.equalTo(60)
            make.leading.equalTo(arrowImageView.snp.trailing).offset(Constants.ReturnTypeButton.insetLeading)
            make.centerY.equalToSuperview()
        }
    }
    
}

private extension FunctionBlockCell {
    func setupBindings() {
        returnTypeButton.tapPublisher
            .sink { [weak self] in
                self?.viewModel?.didChangeType()
                self?.updateAppearanceTypeButton()
            }
            .store(in: &subscriptions)
    }
}
