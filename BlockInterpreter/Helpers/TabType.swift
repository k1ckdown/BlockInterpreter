//
//  TabType.swift
//  BlockInterpreter
//
//  Created by Ivan Semenov on 02.05.2023.
//

import UIKit

enum TabType: CaseIterable {
    case codeblocks, workspace, console
    
    var title: String {
        switch self {
        case .codeblocks:
            return "CodeBlocks"
        case .workspace:
            return "Workspace"
        case .console:
            return "Console"
        }
    }
    
    var orderNumber: Int {
        switch self {
        case .codeblocks:
            return 0
        case .workspace:
            return 1
        case .console:
            return 2
        }
    }
    
    var image: UIImage? {
        switch self {
        case .codeblocks:
            return UIImage(named: "codeblocks-icon")
        case .workspace:
            return UIImage(named: "workspace-icon")
        case .console:
            return UIImage(named: "console-icon")
        }
    }
    
    var imageSelected: UIImage? {
        switch self {
        case .codeblocks:
            return UIImage(named: "codeblocks-icon-selected")
        case .workspace:
            return UIImage(named: "workspace-icon-selected")
        case .console:
            return UIImage(named: "console-icon-selected")
        }
    }
}
