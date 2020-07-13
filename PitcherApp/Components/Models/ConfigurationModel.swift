//
//  ConfigurationModel.swift
//  PitcherApp
//
//  Created by Bogdan Nikolaev on 13.07.2020.
//  Copyright © 2020 Bogdan Nikolaev. All rights reserved.
//

import Foundation

struct ConfigurationModel {
    let pitch: Double
    let overlap: Double
    let volume: Double
    let reverb: Bool

    init(pitch: Double, overlap: Double, volume: Double, reverb: Bool = false) {
        self.pitch = pitch
        self.overlap = overlap
        self.volume = volume
        self.reverb = reverb
    }
}
