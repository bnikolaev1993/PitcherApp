//
//  ApplyFilterUseCase.swift
//  PitcherApp
//
//  Created by Bogdan Nikolaev on 13.07.2020.
//  Copyright © 2020 Bogdan Nikolaev. All rights reserved.
//

import AVKit
import AudioKit
import Foundation
import PromiseKit

struct ApplyFilterUseCaseInput {
    public let avURLS: AVTulip
    public let configurationModel: ConfigurationModel

    public init(avURLS: AVTulip, configurationModel: ConfigurationModel) {
        self.avURLS = avURLS
        self.configurationModel = configurationModel
    }
}

class ApplyFilterUseCase: AsyncUseCase<ApplyFilterUseCaseInput, (video: URL, audio: AVAsset)> {
    override func executeUseCase(resolver: Resolver<(video: URL, audio: AVAsset)>) {
        do {
            let audioFile = try AKAudioFile(forReading: input.avURLS.audio)
            let akAudioPlayer = try AKAudioPlayer(file: audioFile)
            let timePitch = AKTimePitch(akAudioPlayer)

            timePitch.rate = 1.0
            timePitch.pitch = input.configurationModel.pitch
            timePitch.overlap = input.configurationModel.overlap

            // Add reverberation if needed
            if input.configurationModel.reverb {
                let reverb = AKReverb()
                akAudioPlayer >>> reverb >>> timePitch
            }

            AudioKit.output = timePitch
            akAudioPlayer.volume = input.configurationModel.volume

            guard let url = Constants.filteredAudioURL else {
                resolver.reject(DomainError.generalWithDoNothing)
                return
            }

            if FileManager.default.fileExists(atPath: url.path) {
                do {
                    try FileManager.default.removeItem(atPath: url.path)
                } catch {
                    resolver.reject(DomainError.generalWithMessage("Copied Video is not removed"))
                }
            }

            let outputFile = try AKAudioFile(forWriting: url, settings: [:])
            _ = AudioKit.engine.isRunning
            try AudioKit.renderToFile(outputFile, duration: akAudioPlayer.duration, prerender: {
                akAudioPlayer.start()
            }, progress: { progress in
                if progress == 1.0 {
                    do {
                        let asset = try AKAudioFile(forReading: url)
                        resolver.fulfill((video: self.input.avURLS.video, audio: asset.avAsset))
                    } catch {
                        resolver.reject(DomainError.generalWithDoNothing)
                    }
                }
            })
        } catch {
            resolver.reject(DomainError.generalWithDoNothing)
        }
    }
}
