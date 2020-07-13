//
//  ApplyFilterViewController.swift
//  PitcherApp
//
//  Created by Bogdan Nikolaev on 12.07.2020.
//  Copyright © 2020 Bogdan Nikolaev. All rights reserved.
//

import AVKit
import UIKit

class ApplyFilterViewController: BaseViewController<ApplyFilterViewModel, ApplyFilterView> {

    var coordinator: ApplyFilterCoordinator
    let avPlayerController = AVPlayerViewController()

    init(coordinator: ApplyFilterCoordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func createViewModel() -> ApplyFilterViewModel {
        return ApplyFilterViewModel(videoManager: VideoManager(videoURL: coordinator.videoURL))
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addButtonHandlers()

        avPlayerController.player = mainView.avPlayer
        avPlayerController.view.frame = .zero

        // Turn on video controlls
        avPlayerController.showsPlaybackControls = true

        mainView.addPlayer(view: avPlayerController.view)
        self.addChild(avPlayerController)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainView.avPlayer.play()
    }

    override func viewWillDisappear(_ animated: Bool) {
        mainView.avPlayer.pause()
        super.viewWillDisappear(animated)
    }

    func addButtonHandlers() {
        mainView.addFilterButton.addTarget(self, action: #selector(addFilterButtonPressed), for: .touchUpInside)
    }

    @objc func addFilterButtonPressed() {
        avPlayerController.player?.pause()
        mainView.viewModel.applyFilter { [weak self] url in
            guard let self = self else { return }
            self.avPlayerController.player = AVPlayer(url: url)
            self.avPlayerController.player?.play()
        }
    }
}
