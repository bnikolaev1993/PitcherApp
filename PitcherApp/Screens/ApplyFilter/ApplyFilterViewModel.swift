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

    init(videoManager: VideoManager) {
        self.videoManager = videoManager
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }

    func applyFilter(doneClosure: @escaping (URL) -> Void) {
        let videoInput = CopyVideoAssetUseCaseInput(videoURL: videoManager.videoURL)
        _ = CopyVideoAssetUseCase(input: videoInput).actWith(.none).then { url -> Promise<AVTulip> in
            let input = RemoveAudioFileFromVideoUseCaseInput(videoAsset: url)
            return RemoveAudioFileFromVideoUseCase(input: input).actWith(.none)
        }.then { tulpan -> Promise<(video: URL, audio: AVAsset)> in
            let input = ApplyFilterUseCaseInput(audioURL: tulpan.audio, videoURL: tulpan.video)
            return ApplyFilterUseCase(input: input).actWith(.none)
        }.then { tulpan -> Promise<URL> in
            let input = MergeAudioAndVideoUseCaseInput(videoURL: tulpan.video, audioURL: tulpan.audio)
            return MergeAudioAndVideoUseCase(input: input).actWith(.none)
        }.done { videoUrl in
            doneClosure(videoUrl)
        }
    }
}
