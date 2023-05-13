//
//  FlowBlockCell.swift
//  BlockInterpreter
//

import UIKit

class FlowBlockCell: BlockCell {
    
    static let identifier = "FlowBlockCell"
    
    private let flowStackView = UIStackView()
    private(set) var endButton = UIButton()
    private(set) var beganButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        setupContainerView()
        setupFlowStackView()
        setupEndButton()
        setupBeganButton()
    }
    
    private func setupContainerView() {
        containerView.layer.borderWidth = 0
    }
    
    private func setupFlowStackView() {
        containerView.addSubview(flowStackView)
        
        flowStackView.axis = .horizontal
        flowStackView.distribution = .fillEqually
        flowStackView.spacing = 25
        flowStackView.backgroundColor = .clear
        
        flowStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    private func setupEndButton() {
        flowStackView.addArrangedSubview(endButton)

        endButton.setTitle("END", for: .normal)
        endButton.setTitleColor(.appBlack, for: .normal)
        endButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        endButton.backgroundColor = .appTeal
        endButton.layer.cornerRadius = 10
        endButton.layer.borderColor = UIColor.blockBorder?.cgColor
        endButton.layer.borderWidth = 1
    }

    private func setupBeganButton() {
        flowStackView.addArrangedSubview(beganButton)

        beganButton.setTitle("BEGAN", for: .normal)
        beganButton.setTitleColor(.appBlack, for: .normal)
        beganButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        beganButton.backgroundColor = .appPurple
        beganButton.layer.cornerRadius = 10
        beganButton.layer.borderColor = UIColor.blockBorder?.cgColor
        beganButton.layer.borderWidth = 1
        
    }

}
