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
    
    var isWiggleMode: Bool = false {
        didSet {
            updateWiggleModeAppearance()
        }
    }
    
    private enum Constants {
        
            enum ContainerView {
                static let insetLeading: CGFloat = 8
                static let borderWidth: CGFloat = 2.5
            }
        
            enum DeleteButton {
                static let inset: CGFloat = 23
                static let size: CGFloat = 27
                static let cornerRadius: CGFloat = size / 2
            }
        
    }
    
    private(set) var deleteButton = UIButton()
    private(set) var containerView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        containerView.snp.removeConstraints()
        containerView.layer.borderColor = isSelectedState == true ? UIColor.appMain?.cgColor : UIColor.appGray?.cgColor
    }
    
    func select() {
        isSelectedState.toggle()
    }
    
    private func updateAppearance() {
        UIView.transition(
            with: containerView,
            duration: 0.4,
            options: [.transitionFlipFromBottom]
        ) {
            self.containerView.layer.opacity = self.isSelectedState == true ? 0.77 : 1
            self.containerView.layer.borderColor = self.isSelectedState == true ? UIColor.appMain?.cgColor : UIColor.appGray?.cgColor
        }
    }
    
    private func showDeleteButton() {
        deleteButton.isHidden = false
        containerView.layer.borderColor = UIColor.clear.cgColor
    }
    
    private func hideDeleteButton() {
        deleteButton.isHidden = true
        containerView.layer.borderColor = UIColor.appGray?.cgColor
    }
    
    private func updateWiggleModeAppearance() {
        isWiggleMode == true ? activateWiggleMode() : deactivateWiggleMode()
    }
    
    private func activateWiggleMode() {
        startWiggle()
        showDeleteButton()
    }
    
    private func deactivateWiggleMode() {
        stopWiggle()
        hideDeleteButton()
    }
    
    func configure(with viewModel: BlockCellViewModel) {
        containerView.layer.cornerRadius = viewModel.style.cornerRadius
        
        containerView.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(viewModel.style.multiplierHeight())
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(viewModel.style.multiplierWidth(for: viewModel.type))
        }
        
        if viewModel.style == .presentation, !viewModel.type.isEqualTo(.flow) {
            containerView.snp.makeConstraints { make in
                make.leading.equalToSuperview()
            }
        } else if viewModel.style == .work {
            isWiggleMode = viewModel.isWiggleMode
            containerView.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(Constants.ContainerView.insetLeading)
            }
        }
        
        guard viewModel.isSelect != isSelectedState else { return }
        isSelectedState = viewModel.isSelect
    }
    
    private func setup() {
        setupSuperView()
        setupContainerView()
        setupDeleteButton()
    }
    
    private func setupSuperView() {
        backgroundColor = .clear
    }
    
    private func setupContainerView() {
        contentView.addSubview(containerView)
        
        containerView.backgroundColor = .clear
        containerView.layer.borderColor = UIColor.appGray?.cgColor
        containerView.layer.borderWidth = Constants.ContainerView.borderWidth
    }
    
    private func setupDeleteButton() {
        containerView.addSubview(deleteButton)
        
        deleteButton.setImage(UIImage(systemName: "minus"), for: .normal)
        deleteButton.imageView?.tintColor = .appWhite
        deleteButton.backgroundColor = .appGray
        deleteButton.layer.cornerRadius = Constants.DeleteButton.cornerRadius
        deleteButton.isHidden = true
        
        contentView.sendSubviewToBack(containerView)
        
        deleteButton.snp.makeConstraints { make in
            make.trailing.equalTo(containerView.snp.leading).offset(Constants.DeleteButton.inset)
            make.bottom.equalTo(containerView.snp.top).offset(Constants.DeleteButton.inset)
            make.width.height.equalTo(Constants.DeleteButton.size)
        }
    }
    
}

extension BlockCell {
    
    private func degreesToRadians(_ x: CGFloat) -> CGFloat {
        return .pi * x / 180.0
    }
    
    private func stopWiggle() {
        layer.removeAllAnimations()
        transform = .identity
    }
    
    private func startWiggle() {
        let duration: Double = 0.3
        let displacement: CGFloat = 1.0
        let degreesRotation: CGFloat = 2.0
        let negativeDisplacement = -1.0 * displacement
        
        let position = CAKeyframeAnimation.init(keyPath: "position")
        position.beginTime = 0.8
        position.duration = duration
        
        position.values = [
            NSValue(cgPoint: CGPoint(x: negativeDisplacement, y: negativeDisplacement)),
            NSValue(cgPoint: CGPoint(x: 0, y: 0)),
            NSValue(cgPoint: CGPoint(x: negativeDisplacement, y: 0)),
            NSValue(cgPoint: CGPoint(x: 0, y: negativeDisplacement)),
            NSValue(cgPoint: CGPoint(x: negativeDisplacement, y: negativeDisplacement))
        ]
       
        position.calculationMode = .linear
        position.isRemovedOnCompletion = false
        position.repeatCount = Float.greatestFiniteMagnitude
        position.beginTime = CFTimeInterval(Float(arc4random()).truncatingRemainder(dividingBy: Float(25)) / Float(100))
        position.isAdditive = true

        let transform = CAKeyframeAnimation.init(keyPath: "transform")
        transform.beginTime = 2.6
        transform.duration = duration
        transform.valueFunction = CAValueFunction(name: CAValueFunctionName.rotateZ)
        
        transform.values = [
            degreesToRadians(-1.0 * degreesRotation),
            degreesToRadians(degreesRotation),
            degreesToRadians(-1.0 * degreesRotation)
        ]
        
        transform.calculationMode = .linear
        transform.isRemovedOnCompletion = false
        transform.repeatCount = Float.greatestFiniteMagnitude
        transform.isAdditive = true
        transform.beginTime = CFTimeInterval(Float(arc4random()).truncatingRemainder(dividingBy: Float(25)) / Float(100))

       layer.add(position, forKey: "bounce")
       layer.add(transform, forKey: "wiggle")
     }
    
}
