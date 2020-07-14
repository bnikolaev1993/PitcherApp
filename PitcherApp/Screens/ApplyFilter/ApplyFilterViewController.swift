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

        self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .action,
                                                                               target: self,
                                                                               action: #selector(shareVideo)),
                                                               animated: false)

        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        mainView.collectionView.register(CustomCollectionViewCell.self,
                                         forCellWithReuseIdentifier: CustomCollectionViewCell.cellIdentifier)
        mainView.collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .left)


        avPlayerController.player = mainView.avPlayer
        avPlayerController.view.frame = .zero

        // Turn on video controlls
        avPlayerController.showsPlaybackControls = true

        mainView.addPlayer(view: avPlayerController.view)
        self.addChild(avPlayerController)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        avPlayerController.player?.play()
        collectionView(mainView.collectionView, didSelectItemAt: IndexPath(item: 0, section: 0))
    }

    override func viewWillDisappear(_ animated: Bool) {
        avPlayerController.player?.pause()
        super.viewWillDisappear(animated)
    }

    override func updateViewConstraints() {
        if !didSetupConstraints {

            if let view = navigationController?.view {
                mainView.autoPinEdge(.top, to: .top, of: view)
                mainView.autoPinEdge(toSuperviewSafeArea: .bottom)
                mainView.autoPinEdge(toSuperviewSafeArea: .left)
                mainView.autoPinEdge(toSuperviewSafeArea: .right)

                didSetupConstraints = true
            }
        }
        super.updateViewConstraints()
    }

    @objc func shareVideo() {
        avPlayerController.player?.pause()
        guard let videoURL = mainView.viewModel.currentVideoURL else {
            return
        }

        let activityItems: [Any] = [videoURL, "Share this video with your bestie!"]
        let activityController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)

        activityController.popoverPresentationController?.sourceView = mainView
        activityController.popoverPresentationController?.sourceRect = mainView.frame

        self.present(activityController, animated: true, completion: nil)
    }
}

// MARK:- UICollectionViewDelegate, UICollectionViewDataSource
extension ApplyFilterViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mainView.viewModel.presets.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.cellIdentifier,
                                                            for: indexPath) as? CustomCollectionViewCell else {
                                                                return UICollectionViewCell()
        }
        let preset = mainView.viewModel.presets[indexPath.row]
        cell.configure(preset: preset)

        if cell.isSelected {
            cell.setSelected()

            // Make a Human image white when selected
            if indexPath.row == 0 {
                cell.imageView.image = cell.imageView.image?.maskWithColor(color: .white)
            }
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard let prevCellIndexPath = collectionView.indexPathsForSelectedItems?.first,
            let cell = collectionView.cellForItem(at: prevCellIndexPath) as? CustomCollectionViewCell else {
                return true
        }
        cell.setDeselected()
        // Restore default Human color
        if prevCellIndexPath.row == 0 {
            let preset = mainView.viewModel.presets[prevCellIndexPath.row]
            cell.imageView.image = UIImage(named: preset.image)
        }
        return true
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CustomCollectionViewCell else {
            return
        }
        cell.setSelected()

        // Make a Human image white when selected
        if indexPath.row == 0 {
            cell.imageView.image = cell.imageView.image?.maskWithColor(color: .white)
        }
        
        let configuration = mainView.viewModel.presets[indexPath.row].configuration
        avPlayerController.player?.pause()
        mainView.viewModel.applyFilter(configuration: configuration) { [weak self] url in
            guard let self = self else { return }
            self.avPlayerController.player = AVPlayer(url: url)
            self.avPlayerController.player?.play()
        }
    }
}

// MARK:- UICollectionViewDelegateFlowLayout
extension ApplyFilterViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 140)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
