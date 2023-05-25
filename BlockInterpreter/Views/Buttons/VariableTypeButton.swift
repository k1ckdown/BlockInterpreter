//
//  VariableTypeButton.swift
//  BlockInterpreter
//


import UIKit

final class VariableTypeButton: UIButton {
    
    override var isHighlighted: Bool {
        didSet {
            updateAppereance()
        }
    }
    
    var title: String? {
        didSet {
            setTitle(title, for: .normal)
        }
    }

    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateAppereance() {
        backgroundColor = isHighlighted == true ? .secondaryVariableType : .primaryVariableType
    }
    
    private func setup() {
        titleLabel?.font = .typeTitle
        setTitleColor(.appGray, for: .normal)
        titleLabel?.textAlignment = .center
        backgroundColor = .primaryVariableType
        layer.cornerRadius = 8
        layer.borderWidth = 1
        titleEdgeInsets = UIEdgeInsets(top: 0, left: 1, bottom: 0, right: 1)
        layer.borderColor = UIColor.appGray?.cgColor
    }

}
