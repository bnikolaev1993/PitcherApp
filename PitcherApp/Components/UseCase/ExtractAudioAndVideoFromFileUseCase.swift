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


struct ExtractAudioAndVideoFromFileUseCaseInput {
    let videoAssetURL: URL

    init(videoAsset: URL) {
        self.videoAssetURL = videoAsset
    }
}

class ExtractAudioAndVideoFromFileUseCase: AsyncUseCase<ExtractAudioAndVideoFromFileUseCaseInput, AVTulip> {
    override func executeUseCase(resolver: Resolver<AVTulip>) {
        let videoAsset = AVURLAsset(url: input.videoAssetURL)
        let videoComposition = AVMutableComposition()
        let audioComposition = AVMutableComposition()
        let compositionVideoTrack: AVMutableCompositionTrack? = videoComposition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)
        let timeRange: CMTimeRange = CMTimeRangeMake(start: .zero, duration: videoAsset.duration)
        guard let sourceVideoTrack: AVAssetTrack = videoAsset.tracks(withMediaType: .video).first else {
            resolver.reject(DomainError.presetsAreNotExtracted)
            return
        }

        // VIDEO
        // Extracting video
        do {
            _ = try compositionVideoTrack?.insertTimeRange(timeRange, of: sourceVideoTrack, at: .zero)
        } catch {
            resolver.reject(DomainError.presetsAreNotExtracted)
        }
        
        // Rotate extracted Video for Portrait
        compositionVideoTrack?.preferredTransform = CGAffineTransform(rotationAngle: .pi / 2)


        // AUDIO
        let sourceAudioTracks: [AVAssetTrack] = videoAsset.tracks(withMediaType: .audio)
        // Extracting audio
        // Adding them to a new AVAsset
        for track in sourceAudioTracks {
            let compositionTrack = audioComposition.addMutableTrack(withMediaType: .audio,
                                                               preferredTrackID: kCMPersistentTrackID_Invalid)
            do {
                // Add the current audio track at the beginning of
                // the asset for the duration of the source AVAsset
                try compositionTrack?.insertTimeRange(track.timeRange,
                                                      of: track,
                                                      at: track.timeRange.start)
            } catch {
                resolver.reject(DomainError.presetsAreNotExtracted)
            }
        }

        let input = SaveAssetUseCaseInput(asset: videoComposition,
                                          presetName: AVAssetExportPresetHighestQuality,
                                          outputFile: .mov,
                                          path: Constants.extractedVideo)
        _ = SaveAssetUseCase(input: input).act().done { videoUrl in
            let input = SaveAssetUseCaseInput(asset: audioComposition,
                                              presetName: AVAssetExportPresetAppleM4A,
                                              outputFile: .m4a,
                                              path: Constants.extractedAudio)
            _ = SaveAssetUseCase(input: input).act().done { audioUrl in
                resolver.fulfill((video: videoUrl, audio: audioUrl))
            } .catch {
                resolver.reject($0)
            }
        } .catch {
            resolver.reject($0)
        }
    }
}
