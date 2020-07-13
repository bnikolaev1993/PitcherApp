//
//  MainViewController.swift
//  PitcherApp
//
//  Created by Bogdan Nikolaev on 12.07.2020.
//  Copyright © 2020 Bogdan Nikolaev. All rights reserved.
//

import MobileCoreServices
import UIKit

class MainViewController: BaseViewController<BaseViewModel, MainView>, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    let selectVideoFromLibraryVC = UIImagePickerController()

    let coordinator: MainCoordinator

    // MARK:- Initializer
    init(coordinator: MainCoordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK:- Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func setupButtonHandlers() {
        mainView.addButtonPressed = {
            self.getMovie()
        }
    }

    func getMovie() {
        selectVideoFromLibraryVC.delegate = self
        selectVideoFromLibraryVC.mediaTypes = [kUTTypeMovie as String]
        selectVideoFromLibraryVC.allowsEditing = false
        selectVideoFromLibraryVC.sourceType = .photoLibrary

        present(selectVideoFromLibraryVC, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let videoURL = info[.mediaURL] as? URL else { return }
        selectVideoFromLibraryVC.dismiss(animated: true) {
            self.coordinator.goToApplyFiltersScreen(videoURL: videoURL)
        }

    }
}

