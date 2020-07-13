//
//  MergeAudioAndVideoUseCase.swift
//  PitcherApp
//
//  Created by Bogdan Nikolaev on 13.07.2020.
//  Copyright © 2020 Bogdan Nikolaev. All rights reserved.
//

import AVKit
import Foundation
import PromiseKit

struct MergeAudioAndVideoUseCaseInput {
    let videoURL: URL
    let audioURL: AVAsset

    init(videoURL: URL, audioURL: AVAsset) {
        self.videoURL = videoURL
        self.audioURL = audioURL
    }
}

class MergeAudioAndVideoUseCase: AsyncUseCase<MergeAudioAndVideoUseCaseInput, URL> {
    override func executeUseCase(resolver: Resolver<URL>) {
        let mixComposition = AVMutableComposition()
        //start merge

        let aVideoAsset = AVAsset(url: input.videoURL)
        let aAudioAsset = input.audioURL

        let compositionAddVideo = mixComposition.addMutableTrack(withMediaType: .video,
                                                                 preferredTrackID: kCMPersistentTrackID_Invalid)

        let compositionAddAudio = mixComposition.addMutableTrack(withMediaType: .audio,
                                                                 preferredTrackID: kCMPersistentTrackID_Invalid)

        guard let aVideoAssetTrack: AVAssetTrack = aVideoAsset.tracks(withMediaType: .video).first, let aAudioAssetTrack: AVAssetTrack = aAudioAsset.tracks(withMediaType: .audio).first else {
            resolver.reject(DomainError.generalWithDoNothing)
            return
        }

        // Default must have tranformation
        compositionAddVideo?.preferredTransform = aVideoAssetTrack.preferredTransform

        do {
            try compositionAddVideo?.insertTimeRange(CMTimeRangeMake(start: .zero,
                                                                     duration: aVideoAssetTrack.timeRange.duration),
                                                     of: aVideoAssetTrack,
                                                     at: .zero)

            try compositionAddAudio?.insertTimeRange(CMTimeRangeMake(start: .zero,
                                                                     duration: aAudioAssetTrack.timeRange.duration),
                                                     of: aAudioAssetTrack,
                                                     at: .zero)
        } catch {
            print(error.localizedDescription)
        }

        let input = SaveAssetUseCaseInput(asset: mixComposition,
                                          presetName: AVAssetExportPresetHighestQuality,
                                          outputFile: .mov,
                                          path: Constants.newFilteredFilePath)
        _ = SaveAssetUseCase(input: input).act().done { videoUrl in
            resolver.fulfill(videoUrl)
        }
    }
}
