//
//  BaseCoordinator.swift
//  PitcherApp
//
//  Created by Bogdan Nikolaev on 12.07.2020.
//  Copyright © 2020 Bogdan Nikolaev. All rights reserved.
//

import UIKit

class BaseCoordinator<VM: BaseViewModel, V: BaseView<VM>, VC: BaseViewController<VM, V>>: CoordinatorProtocol {
    typealias ViewController = VC
    
    var viewController: VC?

    var root: UINavigationController?

    init(root: UINavigationController?) {
        self.root = root
    }

    func createViewController() -> VC {
        assert(false, "Must be implepented in all subclasses!")
        return VC()
    }

    func configure(viewController: VC) {
        assert(false, "Must be implepented in all subclasses!")
    }

    func start(animated: Bool = true) {
        let vc = createViewController()
        configure(viewController: vc)

        guard let root = self.root else {
            return
        }
        root.pushViewController(vc, animated: animated)

        self.viewController = vc
    }

    func stop(animated: Bool = true) {
        self.viewController = nil
        guard let root = self.root else {
            return
        }
        _ = root.popViewController(animated: animated)
    }
}
