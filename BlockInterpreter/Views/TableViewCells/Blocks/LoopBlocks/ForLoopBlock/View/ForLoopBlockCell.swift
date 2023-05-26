//
//  ForLoopBlockCell.swift
//  BlockInterpreter
//

import UIKit
import Combine

final class ForLoopBlockCell: BlockCell {
    
    static let identifier = "ForLoopBlockCell"
    
    var subscriptions = Set<AnyCancellable>()
    
    private enum Constants {
        
            enum BlockTitleLabel {
                static let insetLeading: CGFloat = 17
            }
            
            enum OpenBracketLabel {
                static let insetLeading: CGFloat = 10
            }
            
            enum FullConditionStackView {
                static let spacing: CGFloat = 7
                static let insetLeading: CGFloat = 2
                static let insetTrailing: CGFloat = 17
                static let insetTopBottom: CGFloat = 15
            }
            
            enum InputTextField {
                static let multiplierWidth: CGFloat = 0.88
            }
            
            enum SeparatorLabel {
                static let insetLeading: CGFloat = 2
            }
        
    }
    
    private(set) var initValueTextField = BlockTextField()
    private(set) var conditionValueTextField = BlockTextField()
    private(set) var stepValueTextField = BlockTextField()
    
    private let blockTitleLabel = UILabel()
    private let fullConditionStackView = UIStackView()
    private lazy var openBracketLabel = BlockSeparatorLabel(separatorType: .bracket(.open))
    
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
        initValueTextField.text = nil
        conditionValueTextField.text = nil
        stepValueTextField.text = nil
    }
    
    func configure(with viewModel: ForLoopBlockCellViewModel) {
        super.configure(with: viewModel)
        
        blockTitleLabel.text = viewModel.title
        initValueTextField.text = viewModel.initValue
        conditionValueTextField.text = viewModel.conditionValue
        stepValueTextField.text = viewModel.stepValue
    }
    
    private func setup() {
        setupContainerView()
        setupBlockTitleLabel()
        setupOpenBracketLabel()
        setupFullConditionStackView()
    }
    
    private func setupContainerView() {
        containerView.backgroundColor = .loopBlock
    }
    
    private func setupBlockTitleLabel() {
        containerView.addSubview(blockTitleLabel)

        blockTitleLabel.font = .blockTitle
        blockTitleLabel.textColor = .appBlack
        blockTitleLabel.textAlignment = .center

        blockTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.BlockTitleLabel.insetLeading)
            make.centerY.equalToSuperview()
        }
    }
    
    private func setupOpenBracketLabel() {
        containerView.addSubview(openBracketLabel)

        openBracketLabel.snp.makeConstraints { make in
            make.leading.equalTo(blockTitleLabel.snp.trailing).offset(Constants.OpenBracketLabel.insetLeading)
            make.centerY.equalToSuperview()
        }
    }
    
    private func setupFullConditionStackView() {
        containerView.addSubview(fullConditionStackView)
        
        fullConditionStackView.spacing = Constants.FullConditionStackView.spacing
        fullConditionStackView.axis = .horizontal
        fullConditionStackView.distribution = .fillEqually
        fullConditionStackView.backgroundColor = .clear
        
        fullConditionStackView.addArrangedSubview(
            makePartConditionView(
                inputTextField: initValueTextField,
                separatorType: .semicolon)
        )
        
        fullConditionStackView.addArrangedSubview(
            makePartConditionView(
                inputTextField: conditionValueTextField,
                separatorType: .semicolon)
        )
        
        
        fullConditionStackView.addArrangedSubview(
            makePartConditionView(
                inputTextField: stepValueTextField,
                separatorType: .bracket(.close))
        )
        
        fullConditionStackView.snp.makeConstraints { make in
            make.leading.equalTo(openBracketLabel.snp.trailing).offset(Constants.FullConditionStackView.insetLeading)
            make.top.bottom.equalToSuperview().inset(Constants.FullConditionStackView.insetTopBottom)
            make.trailing.equalToSuperview().inset(Constants.FullConditionStackView.insetTrailing)
        }
    }
    
    private func makePartConditionView(inputTextField: BlockTextField, separatorType: SeparatorType) -> UIView {
        let view = UIView()
        
        view.addSubview(inputTextField)
        inputTextField.tintColor = .loopBlock
        
        let separatorLabel = BlockSeparatorLabel(separatorType: separatorType)
        view.addSubview(separatorLabel)
        
        inputTextField.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(Constants.InputTextField.multiplierWidth)
            make.leading.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        
        separatorLabel.snp.makeConstraints { make in
            make.leading.equalTo(inputTextField.snp.trailing).offset(Constants.SeparatorLabel.insetLeading)
            make.top.bottom.equalToSuperview()
        }
        
        return view
    }
    
}
