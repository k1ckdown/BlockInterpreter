//
//  TabType.swift
//  BlockInterpreter
//
//  Created by Ivan Semenov on 02.05.2023.
//

import UIKit

enum TabType: CaseIterable {
    case codeblocks, workspace, settings
    
    var title: String {
        switch self {
        case .codeblocks:
            return "CodeBlocks"
        case .workspace:
            return "Workspace"
        case .settings:
            return "Settings"
        }
    }
    
    var orderNumber: Int {
        switch self {
        case .codeblocks:
            return 0
        case .workspace:
            return 1
        case .settings:
            return 2
        }
    }
    
    var image: UIImage? {
        switch self {
        case .codeblocks:
            return UIImage(systemName: "square.stack.3d.up.fill")
        case .workspace:
            return UIImage(systemName: "ellipsis.curlybraces")
        case .settings:
            return UIImage(systemName: "gear")
        }
    }
    
    var imageSelected: UIImage? {
        switch self {
        case .codeblocks:
            return UIImage(named: "codeblocks-icon-selected")
        case .workspace:
            return UIImage(named: "workspace-icon-selected")
        case .settings:
            return UIImage(named: "settings-icon-selected")
        }
    }
}
