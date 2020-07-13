//
//  CreateVideoAssetUseCase.swift
//  PitcherApp
//
//  Created by Bogdan Nikolaev on 13.07.2020.
//  Copyright © 2020 Bogdan Nikolaev. All rights reserved.
//

import AVKit
import Foundation
import PromiseKit

struct CopyVideoAssetUseCaseInput {
    public let videoURL: URL

    public init(videoURL: URL) {
        self.videoURL = videoURL
    }
}

class CopyVideoAssetUseCase: AsyncUseCase<CopyVideoAssetUseCaseInput, URL> {
    override func executeUseCase(resolver: Resolver<URL>) {
        let sourceAsset = AVURLAsset(url: input.videoURL)
        let input = SaveAssetUseCaseInput(asset: sourceAsset,
                                          presetName: AVAssetExportPresetHighestQuality,
                                          outputFile: .mov,
                                          path: NSTemporaryDirectory() + "out.mov")
        _ = SaveAssetUseCase(input: input).act().done {
            resolver.fulfill($0)
        } .catch {
            resolver.reject($0)
        }
    }
}

