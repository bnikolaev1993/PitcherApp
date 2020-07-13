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

struct CreateVideoAssetUseCaseInput {
    public let videoURL: URL

    public init(videoURL: URL) {
        self.videoURL = videoURL
    }
}

class CopyVideoAssetUseCase: AsyncUseCase<CreateVideoAssetUseCaseInput, AVURLAsset> {
    override func executeUseCase(resolver: Resolver<AVURLAsset>) {
        let sourceAsset = AVURLAsset(url: input.videoURL, options: nil)
        resolver.fulfill(sourceAsset)
    }
}

