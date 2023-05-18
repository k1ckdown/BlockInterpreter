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
            applyWiggleModeAppearance()
        }
    }
    
    private enum Constants {
            enum ContainerView {
                static let borderWidth: CGFloat = 2.5
                static let insetLeading: CGFloat = 8
            }
    }
    
    private(set) var deleteButton = UIButton()
    private(set) var containerView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
        selectionStyle = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        containerView.snp.removeConstraints()
        containerView.layer.borderColor = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func select() {
        isSelectedState.toggle()
    }
    
    private func updateAppearance() {
        containerView.layer.borderColor = isSelectedState == true ? UIColor.appMain?.cgColor : UIColor.blockBorder?.cgColor
    }
    
    private func showDeleteButton() {
        deleteButton.isHidden = false
        containerView.layer.borderColor = UIColor.clear.cgColor
    }
    
    private func hideDeleteButton() {
        deleteButton.isHidden = true
        containerView.layer.borderColor = UIColor.blockBorder?.cgColor
    }
    
    private func applyWiggleModeAppearance() {
        if isWiggleMode {
            startWiggle()
            showDeleteButton()
        } else {
            stopWiggle()
            hideDeleteButton()
        }
    }
    
    func configure(with viewModel: BlockCellViewModel) {
        isSelectedState = viewModel.isSelect
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
            containerView.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(Constants.ContainerView.insetLeading)
            }
            
            applyWiggleModeAppearance()
        }
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
        containerView.layer.borderColor = UIColor.clear.cgColor
        containerView.layer.borderWidth = Constants.ContainerView.borderWidth
    }
    
    private func setupDeleteButton() {
        containerView.addSubview(deleteButton)
        
        deleteButton.setTitle("-", for: .normal)
        deleteButton.setTitleColor(.blockBorder, for: .normal)
        deleteButton.backgroundColor = .darkGray
        deleteButton.layer.cornerRadius = 12.5
        deleteButton.isHidden = true
        
        contentView.sendSubviewToBack(containerView)
        
        deleteButton.snp.makeConstraints { make in
            make.trailing.equalTo(containerView.snp.leading).offset(22)
            make.bottom.equalTo(containerView.snp.top).offset(22)
            make.width.height.equalTo(25)
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
        let duration: Double = 0.25
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
