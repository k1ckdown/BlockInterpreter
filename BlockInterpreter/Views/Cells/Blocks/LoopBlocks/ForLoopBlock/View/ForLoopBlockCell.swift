//
//  ForLoopBlockCell.swift
//  BlockInterpreter
//

import UIKit
import Combine

final class ForLoopBlockCell: BlockCell {
    
    static let identifier = "ForLoopBlockCell"
    
    var subscriptions = Set<AnyCancellable>()
    
    private(set) var initValueTextField = BlockTextField()
    private(set) var conditionValueTextField = BlockTextField()
    private(set) var stepValueTextField = BlockTextField()
    
    private let blockTitleLabel = UILabel()
    private let fullConditionStackView = UIStackView()
    private lazy var openBracketLabel: UILabel = {
        let label = makeSeparatorLabel(separatorType: .bracket(.open))
        return label
    }()
    
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
            make.leading.equalToSuperview().offset(17)
            make.centerY.equalToSuperview()
        }
    }
    
    private func setupOpenBracketLabel() {
        containerView.addSubview(openBracketLabel)

        openBracketLabel.snp.makeConstraints { make in
            make.leading.equalTo(blockTitleLabel.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
        }
    }
    
    private func setupFullConditionStackView() {
        containerView.addSubview(fullConditionStackView)
        
        fullConditionStackView.spacing = 7
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
            make.leading.equalTo(openBracketLabel.snp.trailing).offset(2)
            make.top.bottom.equalToSuperview().inset(15)
            make.trailing.equalToSuperview().inset(17)
        }
    }
    
    private func makeSeparatorLabel(separatorType: ConditionSeparatorType) -> UILabel {
        let label = UILabel()
        
        label.text = separatorType.title
        label.font = .blockTitle
        label.textColor = .appBlack
        label.textAlignment = .center
        
        return label
    }
    
    private func makePartConditionView(inputTextField: BlockTextField, separatorType: ConditionSeparatorType) -> UIView {
        let view = UIView()
        
        view.addSubview(inputTextField)
        
        let separatorLabel = makeSeparatorLabel(separatorType: separatorType)
        view.addSubview(separatorLabel)
        
        inputTextField.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.88)
            make.leading.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        
        separatorLabel.snp.makeConstraints { make in
            make.leading.equalTo(inputTextField.snp.trailing).offset(2)
            make.top.bottom.equalToSuperview()
        }
        
        return view
    }
    
}
