//
//  BaseView.swift
//  PitcherApp
//
//  Created by Bogdan Nikolaev on 12.07.2020.
//  Copyright © 2020 Bogdan Nikolaev. All rights reserved.
//

import UIKit

class BaseView<VM: BaseViewModel>: UIView, ViewProtocol {
    var didSetupConstraints = false

    var viewModel: VM

    required init(viewModel: VM, frame: CGRect = .zero) {
        self.viewModel = viewModel
        super.init(frame: frame)
        configureForAutoLayout()
        configureComponents()
        addComponents()
        needsUpdateConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureComponents() {
        fatalError("Should be implemented in a sub-class")
    }

    func addComponents() {
        fatalError("Should be implemented in a sub-class")
    }
}
