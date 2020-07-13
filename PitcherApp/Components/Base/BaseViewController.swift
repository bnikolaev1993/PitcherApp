//
//  BaseViewController.swift
//  PitcherApp
//
//  Created by Bogdan Nikolaev on 12.07.2020.
//  Copyright © 2020 Bogdan Nikolaev. All rights reserved.
//

import PureLayout
import UIKit

class BaseViewController<VM: BaseViewModel, ViewT: BaseView<VM>>: UIViewController {
    var mainView: ViewT!
    var didSetupConstraints = false

    // MARK:- Lifecycle
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white

        configureMainView()
        setupButtonHandlers()

        view.setNeedsUpdateConstraints()
    }

    func configureMainView() {
        mainView = ViewT(viewModel: createViewModel())
        view.addSubview(mainView)
    }

    func createViewModel() -> VM {
        return VM()
    }

    func setupButtonHandlers() { }

    override func updateViewConstraints() {
        if !didSetupConstraints {
            
            mainView.autoPinEdgesToSuperviewEdges()

            didSetupConstraints = true
        }

        super.updateViewConstraints()
    }
}
