//
//  OptionsView.swift
//  BlockInterpreter
//

import UIKit
import Combine

final class OptionsView: UIView {
    
    var subscriptions = Set<AnyCancellable>()
    var titleText: String? {
        didSet {
            titleOptionLabel.text = titleText
        }
    }
    
    private enum Constants {
        
            enum View {
                static let cornerRadius: CGFloat = 10
            }
            
            enum IconOptionImageView {
                static let size: CGFloat = 25
                static let insetLeading: CGFloat = 22
            }
            
            enum TitleOptionLabel {
                static let insetLeading: CGFloat = 11
            }
        
    }
    
    private let configuration: OptionsViewConfiguration
    
    private let titleOptionLabel = UILabel()
    private let iconOptionImageView = UIImageView()
    
    private(set) var tapGesture = UITapGestureRecognizer()
    private let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterial))
    
    init(configuration: OptionsViewConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        setupView()
        setupVisualEffectView()
        setupIconOptionImageView()
        setupTitleOptionLabel()
    }
    
    private func setupView() {
        backgroundColor = .clear
        layer.cornerRadius = Constants.View.cornerRadius
        layer.masksToBounds = true
        addGestureRecognizer(tapGesture)
    }
    
    private func setupVisualEffectView() {
        addSubview(visualEffectView)
        
        visualEffectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupIconOptionImageView() {
        addSubview(iconOptionImageView)
        
        iconOptionImageView.contentMode = .scaleAspectFit
        iconOptionImageView.image = configuration.image
        iconOptionImageView.tintColor = configuration.imageTintColor
        
        iconOptionImageView.snp.makeConstraints { make in
            make.width.height.equalTo(Constants.IconOptionImageView.size)
            make.leading.equalToSuperview().offset(Constants.IconOptionImageView.insetLeading)
            make.centerY.equalToSuperview()
        }
    }
    
    private func setupTitleOptionLabel() {
        addSubview(titleOptionLabel)
        
        titleOptionLabel.font = .optionsTitle
        titleOptionLabel.textColor = configuration.titleColor
        
        titleOptionLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconOptionImageView.snp.trailing).offset(Constants.TitleOptionLabel.insetLeading)
            make.centerY.equalToSuperview()
        }
    }

}
