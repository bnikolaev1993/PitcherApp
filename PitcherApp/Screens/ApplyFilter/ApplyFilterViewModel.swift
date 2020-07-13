//
//  ApplyFilterViewModel.swift
//  PitcherApp
//
//  Created by Bogdan Nikolaev on 12.07.2020.
//  Copyright © 2020 Bogdan Nikolaev. All rights reserved.
//

import AVKit
import Foundation
import PromiseKit

class ApplyFilterViewModel: BaseViewModel {
    let videoManager: VideoManager
    var presets: [PresetModel] = [PresetModel]()
    var currentVideoURL: URL?

    init(videoManager: VideoManager) {
        self.videoManager = videoManager
        presets.append(contentsOf: [PresetModel(name: "Human",
                                                image: "human",
                                                configurationModel: ConfigurationModel(pitch: 0, overlap: 8, volume: 1)),
                                    PresetModel(name: "Devil",
                                                image: "devil",
                                                configurationModel: ConfigurationModel(pitch: -800, overlap: 8, volume: 2, reverb: true)),
                                    PresetModel(name: "Angel",
                                                image: "angel",
                                                configurationModel: ConfigurationModel(pitch: 500, overlap: 8, volume: 1, reverb: true)),
                                    PresetModel(name: "Humster",
                                                image: "humster",
                                                configurationModel: ConfigurationModel(pitch: 1200, overlap: 8, volume: 1))])
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }

    func applyFilter(configuration: ConfigurationModel, doneClosure: @escaping (URL) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let videoInput = CopyVideoAssetUseCaseInput(videoURL: self.videoManager.videoURL)
            _ = CopyVideoAssetUseCase(input: videoInput).act().then { url -> Promise<AVTulip> in
                let input = RemoveAudioFileFromVideoUseCaseInput(videoAsset: url)
                return RemoveAudioFileFromVideoUseCase(input: input).act()
            }.then { tulpan -> Promise<(video: URL, audio: AVAsset)> in
                let input = ApplyFilterUseCaseInput(avURLS: tulpan, configurationModel: configuration)
                return ApplyFilterUseCase(input: input).act()
            }.then { tulpan -> Promise<URL> in
                let input = MergeAudioAndVideoUseCaseInput(videoURL: tulpan.video, audioURL: tulpan.audio)
                return MergeAudioAndVideoUseCase(input: input).act()
            }.done { videoUrl in
                self.currentVideoURL = videoUrl
                doneClosure(videoUrl)
            }
        }
    }
}
