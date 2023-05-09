//
//  BlockCell.swift
//  BlockInterpreter
//

import UIKit
import SnapKit

class BlockCell: UITableViewCell {
    
    var isSelectedState = false {
        didSet {
            updateAppearance()
        }
    }
    
    private enum Constants {
            enum ContainerView {
                static let borderWidth: CGFloat = 2
            }
    }
    
    private(set) var containerView = UIView()
    
    private var containerViewHeightConstraint: Constraint?
    private var containerViewWidthConstraint: Constraint?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        setupSuperView()
        setupContainerView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        containerView.layer.borderColor = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        updateAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func select() {
        isSelectedState = !isSelectedState
    }
    
    private func updateAppearance() {
        containerView.layer.borderColor = isSelectedState == true ? UIColor.orange.cgColor : .none
    }
    
    func configure(with viewModel: BlockCellViewModel) {
        isSelectedState = viewModel.isSelect
        containerView.layer.cornerRadius = viewModel.style.cornerRadius
        
        containerViewHeightConstraint?
            .update(offset: contentView.frame.height * viewModel.style.multiplierHeight())
        containerViewWidthConstraint?
            .update(offset: contentView.frame.width * viewModel.style.multiplierWidth(for: viewModel.type))
    }
    
    private func setupSuperView() {
        backgroundColor = .clear
    }
    
    private func setupContainerView() {
        contentView.addSubview(containerView)
        
        containerView.backgroundColor = .clear
        containerView.layer.borderColor = UIColor.clear.cgColor
        containerView.layer.borderWidth = Constants.ContainerView.borderWidth
        
        containerView.snp.makeConstraints { make in
            containerViewHeightConstraint = make.height.equalTo(frame.height).constraint
            make.centerY.equalToSuperview()
            containerViewWidthConstraint = make.width.equalTo(frame.width).constraint
            make.leading.equalToSuperview()
        }
    }
}
