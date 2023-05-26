//
//  TabFlow.swift
//  BlockInterpreter
//

import UIKit

enum TabFlow: CaseIterable {
    case codeblocks, workspace, hub
    
    var title: String {
        switch self {
        case .codeblocks:
            return "CodeBlocks"
        case .workspace:
            return "Workspace"
        case .hub:
            return "Hub"
        }
    }
    
    var orderNumber: Int {
        switch self {
        case .codeblocks:
            return 0
        case .workspace:
            return 1
        case .hub:
            return 2
        }
    }
    
    var image: UIImage? {
        switch self {
        case .codeblocks:
            return UIImage(systemName: "square.stack.3d.up.fill")
        case .workspace:
            return UIImage(systemName: "ellipsis.curlybraces")
        case .hub:
            return UIImage(systemName: "square.grid.2x2")
        }
    }
}
