//
//  PresetModel.swift
//  PitcherApp
//
//  Created by Bogdan Nikolaev on 13.07.2020.
//  Copyright © 2020 Bogdan Nikolaev. All rights reserved.
//

import Foundation

class PresetModel {
    let name: String
    let image: String
    let configuration: ConfigurationModel

    init(name: String, image: String, configurationModel: ConfigurationModel) {
        self.name = name
        self.image = image
        self.configuration = configurationModel
    }
}
