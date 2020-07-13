//
//  MainView.swift
//  PitcherApp
//
//  Created by Bogdan Nikolaev on 12.07.2020.
//  Copyright © 2020 Bogdan Nikolaev. All rights reserved.
//

import PureLayout
import UIKit

class MainView: BaseView<BaseViewModel> {

    lazy var addVideoButton: UIButton = UIButton(frame: .zero)
    @objc var addButtonPressed: (() -> Void)?

    override func configureComponents() {
        addVideoButton.setTitle("Add Video", for: .normal)
        addVideoButton.setTitleColor(.black, for: .normal)
        addVideoButton.addTarget(self, action: #selector(addVideoButtonPressed), for: .touchUpInside)
    }

    override func addComponents() {
        addSubview(addVideoButton)
    }

    override func updateConstraints() {
        if !didSetupConstraints {
            addVideoButton.autoCenterInSuperview()

            didSetupConstraints = true
        }
        super.updateConstraints()
    }

    @objc func addVideoButtonPressed() {
        addButtonPressed?()
    }
}
