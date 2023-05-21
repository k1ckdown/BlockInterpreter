//
//  OptionsToolbar.swift
//  BlockInterpreter
//

import UIKit
import Combine

final class OptionsToolbar: UIToolbar {
    
    var subscriptions = Set<AnyCancellable>()
    var titleText: String? {
        didSet {
            titleOptionLabel.text = titleText
        }
    }
    
    private let configuration: OptionsToolbarConfiguration
    private(set) var toolbarTapGesture = UITapGestureRecognizer()
    
    private lazy var titleOptionLabel: UILabel = {
        let label = UILabel()
        
        label.font = .optionsTitle
        label.textColor = configuration.titleColor
        
        return label
    }()
    
    private lazy var imageOptionImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = configuration.image
        imageView.tintColor = configuration.imageTintColor
        
        return imageView
    }()
    
    private lazy var optionsStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.spacing = 10
        stackView.axis = .horizontal
        stackView.addArrangedSubview(imageOptionImageView)
        stackView.addArrangedSubview(titleOptionLabel)
        stackView.addGestureRecognizer(toolbarTapGesture)
        
        return stackView
    }()
    
    init(configuration: OptionsToolbarConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        barStyle = .black
        layer.masksToBounds = true
        layer.cornerRadius = 10
        frame.size.width = 100
        layer.borderColor = UIColor.blockBorder?.cgColor
        
        let optionBarButton = UIBarButtonItem(customView: optionsStackView)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        items = [flexibleSpace, optionBarButton, flexibleSpace]
    }
}
