//
//  ExtractAudioFileFromVideoUseCase.swift
//  PitcherApp
//
//  Created by Bogdan Nikolaev on 13.07.2020.
//  Copyright © 2020 Bogdan Nikolaev. All rights reserved.
//

import AVKit
import Foundation
import PromiseKit

class RemoveAudioFileFromVideoUseCase: AsyncUseCase<ExtractAudioFileFromVideoUseCaseInput, Void> {
    override func executeUseCase(resolver: Resolver<Void>) {

    }
}

struct ExtractAudioFileFromVideoUseCaseInput {
    let videoAsset: AVURLAsset

    init(videoAsset: AVURLAsset) {
        self.videoAsset = videoAsset
    }
}
