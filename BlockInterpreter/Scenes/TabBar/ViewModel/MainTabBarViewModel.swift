//
//  MainTabBarViewModel.swift
//  BlockInterpreter
//
//  Created by Ivan Semenov on 01.05.2023.
//

import Foundation

final class MainTabBarViewModel {
    
    var didGoToSettingsScreen: (() -> Void)?
    
}

extension MainTabBarViewModel: MainTabBarViewModelType {
    func showSettingsScreen() {
        didGoToSettingsScreen?()
    }
}
