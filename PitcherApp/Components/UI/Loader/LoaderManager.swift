//
//  LoaderManager.swift
//  PitcherApp
//
//  Created by Bogdan Nikolaev on 14.07.2020.
//  Copyright © 2020 Bogdan Nikolaev. All rights reserved.
//

import UIKit

public class LoaderManager {
    static let shared = LoaderManager()

    struct LoaderObject {}

    let loaderQueue = DispatchQueue(label: "com.corelib.LoaderManager")
    private var runningLoaderObjects = [LoaderObject]()

    // Delays are used to prevent quick show/hide when someone chain start/stop
    let startDelay = DispatchTimeInterval.milliseconds(50)
    let stopDelay = DispatchTimeInterval.milliseconds(50)

    // MARK: - Show/Hide actions

    private var showLoader: (UIView) -> Void = { view in
        DispatchQueue.main.async {
            NSLog("LOADER - SHOW - closure")
            LoaderView.show(view)
        }
    }

    private var hideLoader: ((() -> Void)?) -> Void = { completion in
        DispatchQueue.main.async {
            NSLog("LOADER - HIDE - closure")
            LoaderView.hide(completion)
        }
    }

    // MARK: - Start

    func startNew(_ view: UIView) {
        loaderQueue.sync {
            runningLoaderObjects.append(LoaderObject())

            if runningLoaderObjects.count == 1 {
                DispatchQueue.main.asyncAfter(deadline: .now() + startDelay) {
                    if !self.runningLoaderObjects.isEmpty {
                        self.showLoader(view)
                    }
                }
            }
        }
    }

    // MARK: - Stop
    func stop(completion: (() -> Void)? = nil) {
        loaderQueue.sync {
            if !runningLoaderObjects.isEmpty {
                runningLoaderObjects.removeFirst()
            } else {
                return
            }
            if runningLoaderObjects.isEmpty {
                DispatchQueue.main.asyncAfter(deadline: .now() + stopDelay) {
                    if self.runningLoaderObjects.isEmpty {
                        self.hideLoader(completion)
                    }
                }
            }
        }
    }

    func stopAllLoaders(completion: (() -> Void)? = nil) {
        loaderQueue.sync {
            runningLoaderObjects.removeAll()
        }
        hideLoader(completion)
    }
}
