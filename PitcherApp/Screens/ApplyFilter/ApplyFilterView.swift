//
//  ApplyFilterView.swift
//  PitcherApp
//
//  Created by Bogdan Nikolaev on 12.07.2020.
//  Copyright © 2020 Bogdan Nikolaev. All rights reserved.
//

import Photos
import UIKit

class ApplyFilterView: BaseView<ApplyFilterViewModel> {

    var avPlayer: AVPlayer?
    var videoPlayerView = UIView.newAutoLayout()
    var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    var contentStackView = UIStackView.newAutoLayout()

    override func addComponents() {
        addSubview(contentStackView)
    }

    override func configureComponents() {
        avPlayer = AVPlayer(url: viewModel.videoManager.videoURL)
        videoPlayerView.backgroundColor = .black

        collectionView.backgroundColor = .red
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal

        collectionView.setCollectionViewLayout(layout, animated: false)
        collectionView.backgroundColor = .clear
        collectionView.clipsToBounds = false
        collectionView.alwaysBounceHorizontal = true

        contentStackView.alignment = .fill
        contentStackView.distribution = .fill
        contentStackView.axis = .vertical
    }

    func addPlayer(view: UIView) {
        videoPlayerView = view
        contentStackView.addArrangedSubview(videoPlayerView)
        contentStackView.addArrangedSubview(collectionView)
        setNeedsLayout()
    }

    override func updateConstraints() {
        if !didSetupConstraints {
            contentStackView.autoPinEdgesToSuperviewEdges()

            collectionView.autoPinEdge(.top, to: .bottom, of: videoPlayerView, withOffset: 20)
            collectionView.autoSetDimension(.height, toSize: 200)
        }
        super.updateConstraints()
    }
}
