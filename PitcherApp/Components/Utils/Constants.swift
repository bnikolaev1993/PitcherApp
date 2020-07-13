//
//  Constants.swift
//  PitcherApp
//
//  Created by Bogdan Nikolaev on 13.07.2020.
//  Copyright © 2020 Bogdan Nikolaev. All rights reserved.
//

import Foundation

typealias AVTulip = (video: URL, audio: URL)

class Constants {
    static let filteredAudioURL = URL(string: NSTemporaryDirectory() + "newAudioOut.caf")
    static let newFilteredFilePath = NSTemporaryDirectory() + "newFiltered.mov"
    static let extractedVideo = NSTemporaryDirectory() + "extractedVideo.mov"
    static let extractedAudio = NSTemporaryDirectory() + "extractedAudio.m4a"
}
