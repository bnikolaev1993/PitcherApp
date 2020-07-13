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

    var avPlayer: AVPlayer!
    var videoPlayerView: UIView = UIView.newAutoLayout()
    var addFilterButton: UIButton = UIButton.newAutoLayout()

    override func addComponents() {
        addSubview(addFilterButton)
    }

    override func configureComponents() {
        avPlayer = AVPlayer(url: viewModel.videoManager.videoURL)
        videoPlayerView.backgroundColor = .black

        addFilterButton.setTitle("Add Filter", for: .normal)
        addFilterButton.titleLabel?.textAlignment = .center
        addFilterButton.setTitleColor(.black, for: .normal)
    }

    func addPlayer(view: UIView) {
        videoPlayerView = view
        addSubview(videoPlayerView)
    }

    override func updateConstraints() {
        if !didSetupConstraints {
            videoPlayerView.autoPinEdge(toSuperviewEdge: .top, withInset: 20)
            videoPlayerView.autoPinEdge(toSuperviewEdge: .left)
            videoPlayerView.autoPinEdge(toSuperviewEdge: .right)
            videoPlayerView.autoSetDimension(.height, toSize: 500)

            addFilterButton.autoPinEdge(toSuperviewEdge: .bottom)
            addFilterButton.autoPinEdge(toSuperviewEdge: .left, withInset: 20)
            addFilterButton.autoPinEdge(toSuperviewEdge: .bottom, withInset: 20)
            addFilterButton.autoSetDimension(.height, toSize: 40)

        }
        super.updateConstraints()
    }
}
