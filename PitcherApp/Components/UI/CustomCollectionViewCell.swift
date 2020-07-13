//
//  CustomCollectionViewCell.swift
//  PitcherApp
//
//  Created by Bogdan Nikolaev on 13.07.2020.
//  Copyright © 2020 Bogdan Nikolaev. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "customTypeCell"

    var imageView = UIImageView.newAutoLayout()
    var titleLabel = UILabel.newAutoLayout()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addComponents()
        setupComponents()
        layoutComponents()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addComponents() {
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
    }

    func setupComponents() {
        contentView.clipsToBounds = true
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 6

        imageView.contentMode = .scaleAspectFit

        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
    }

    func layoutComponents() {
        titleLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 21)
        titleLabel.autoPinEdge(toSuperviewEdge: .left)
        titleLabel.autoPinEdge(toSuperviewEdge: .right)

        imageView.autoPinEdge(toSuperviewEdge: .top)
        imageView.autoSetDimensions(to: CGSize(width: 96, height: 96))
        imageView.autoPinEdge(toSuperviewEdge: .left, withInset: 3)
    }

    func configure(preset: PresetModel) {
        titleLabel.text = preset.name
        imageView.image = UIImage(named: preset.image)
    }

    func setSelected() {
        contentView.backgroundColor = .black
        titleLabel.textColor = .white
    }

    func setDeselected() {
        contentView.backgroundColor = .white
        titleLabel.textColor = .black
    }
}
