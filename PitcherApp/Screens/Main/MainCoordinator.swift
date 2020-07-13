//
//  MainCoordinator.swift
//  PitcherApp
//
//  Created by Bogdan Nikolaev on 12.07.2020.
//  Copyright © 2020 Bogdan Nikolaev. All rights reserved.
//

import UIKit

class MainCoordinator: BaseCoordinator<BaseViewModel, MainView, MainViewController> {
    override func createViewController() -> MainViewController {
        return MainViewController(coordinator: self)
    }

    override func configure(viewController: MainViewController) {
        root?.isNavigationBarHidden = true
    }

    func goToApplyFiltersScreen(videoURL: URL) {
        let coordinator = ApplyFilterCoordinator(root: root, videoURL: videoURL)
        coordinator.start()
    }
}
