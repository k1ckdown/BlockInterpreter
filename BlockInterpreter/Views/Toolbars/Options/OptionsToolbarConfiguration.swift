//
//  OptionsToolbarConfiguration.swift
//  BlockInterpreter
//

import UIKit

enum OptionsToolbarConfiguration {
    case optionAddBlock
    case optionDeleteAllBlocks
    
    var titleColor: UIColor? {
        switch self {
        case .optionAddBlock:
            return .appWhite
        case .optionDeleteAllBlocks:
            return .appRed
        }
    }
    
    var imageTintColor: UIColor? {
        switch self {
        case .optionAddBlock:
            return .appMain
        case .optionDeleteAllBlocks:
            return .appRed
        }
    }
    
    var image: UIImage? {
        switch self {
        case .optionAddBlock:
            return UIImage(systemName: "plus.circle.fill")
        case .optionDeleteAllBlocks:
            return UIImage(systemName: "trash.fill")
        }
    }
}
