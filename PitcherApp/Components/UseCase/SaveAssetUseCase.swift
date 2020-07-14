//
//  SaveAssetUseCase.swift
//  PitcherApp
//
//  Created by Bogdan Nikolaev on 13.07.2020.
//  Copyright © 2020 Bogdan Nikolaev. All rights reserved.
//

import AVKit
import Foundation
import PromiseKit

struct SaveAssetUseCaseInput {
    let asset: AVAsset
    let presetName: String
    let outputFile: AVFileType
    let path: String

    init(asset: AVAsset, presetName: String, outputFile: AVFileType, path: String) {
        self.asset = asset
        self.presetName = presetName
        self.outputFile = outputFile
        self.path = path
    }
}

class SaveAssetUseCase: AsyncUseCase<SaveAssetUseCaseInput, URL> {
    override func executeUseCase(resolver: Resolver<URL>) {
        // Get url for output
        let outputUrl = URL(fileURLWithPath: input.path)
        if FileManager.default.fileExists(atPath: outputUrl.path) {
            do {
                try FileManager.default.removeItem(atPath: outputUrl.path)
            } catch {
                resolver.reject(DomainError.videoIsNotCopied)
            }
        }

        // Create an export session
        let exportSession = AVAssetExportSession(asset: input.asset, presetName: input.presetName)
        exportSession?.outputFileType = input.outputFile
        exportSession?.outputURL = outputUrl

        // Export file
        exportSession?.exportAsynchronously {
            guard case exportSession?.status = AVAssetExportSession.Status.completed else {
                resolver.reject(DomainError.videoIsNotCopied)
                return
            }
            resolver.fulfill(outputUrl)
        }
    }
}

