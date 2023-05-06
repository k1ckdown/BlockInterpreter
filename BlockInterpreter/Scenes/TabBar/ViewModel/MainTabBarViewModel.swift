//
//  MainTabBarViewModel.swift
//  BlockInterpreter
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
