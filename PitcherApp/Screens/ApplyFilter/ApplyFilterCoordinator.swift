//
//  ApplyFilterCoordinator.swift
//  PitcherApp
//
//  Created by Bogdan Nikolaev on 12.07.2020.
//  Copyright © 2020 Bogdan Nikolaev. All rights reserved.
//

import UIKit

class ApplyFilterCoordinator: BaseCoordinator<ApplyFilterViewModel, ApplyFilterView, ApplyFilterViewController> {

    let videoURL: URL

    init(root: UINavigationController?, videoURL: URL) {
        self.videoURL = videoURL
        super.init(root: root)
    }

    override func createViewController() -> ApplyFilterViewController {
        return ApplyFilterViewController(coordinator: self)
    }

    override func configure(viewController: ApplyFilterViewController) {
        root?.isNavigationBarHidden = false
        viewController.title = "Apply Filter"
    }
}
