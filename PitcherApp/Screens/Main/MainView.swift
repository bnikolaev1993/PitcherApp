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

    lazy var addVideoFromLibraryButton: UIButton = UIButton.newAutoLayout()
    lazy var shootVideoButton = UIButton.newAutoLayout()
    lazy var contentStackView = UIStackView.newAutoLayout()
    @objc var addButtonPressed: ((UIImagePickerController.SourceType) -> Void)?

    override func configureComponents() {
        backgroundColor = .white

        contentStackView.distribution = .equalSpacing
        contentStackView.axis = .vertical
        contentStackView.alignment = .center
        contentStackView.spacing = 20

        addVideoFromLibraryButton.setTitle("Photo Library", for: .normal)
        addVideoFromLibraryButton.setImage(UIImage(systemName: "photo"), for: .normal)
        addVideoFromLibraryButton.setTitleColor(.black, for: .normal)
        addVideoFromLibraryButton.addTarget(self, action: #selector(addVideoButtonPressed), for: .touchUpInside)

        shootVideoButton.setTitle("Shoot Video", for: .normal)
        shootVideoButton.setImage(UIImage(systemName: "camera"), for: .normal)
        shootVideoButton.setTitleColor(.black, for: .normal)
        shootVideoButton.addTarget(self, action: #selector(shootVideoButtonPressed), for: .touchUpInside)
    }

    override func addComponents() {
        addSubview(contentStackView)
        contentStackView.addArrangedSubview(shootVideoButton)
        contentStackView.addArrangedSubview(addVideoFromLibraryButton)
    }

    override func updateConstraints() {
        if !didSetupConstraints {
            contentStackView.autoCenterInSuperview()

            didSetupConstraints = true
        }
        super.updateConstraints()
    }

    @objc func addVideoButtonPressed() {
        addButtonPressed?(.photoLibrary)
    }

    @objc func shootVideoButtonPressed() {
        addButtonPressed?(.camera)
    }
}
