//
//  TabType.swift
//  BlockInterpreter
//
//  Created by Ivan Semenov on 02.05.2023.
//

import UIKit

enum TabType {
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
    
    var nameImageSelected: String {
        switch self {
        case .codeblocks:
            return "codeblocks-icon-selected"
        case .workspace:
            return "workspace-icon-selected"
        case .console:
            return "console-icon-selected"
        }
    }
    
    var nameImageUnselected: String {
        switch self {
        case .codeblocks:
            return "codeblocks-icon-unselected"
        case .workspace:
            return "workspace-icon-unselected"
        case .console:
            return "console-icon-unselected"
        }
    }
}
