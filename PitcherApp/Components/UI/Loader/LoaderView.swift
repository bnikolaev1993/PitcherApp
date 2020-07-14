//
//  LoaderView.swift
//  PitcherApp
//
//  Created by Bogdan Nikolaev on 14.07.2020.
//  Copyright © 2020 Bogdan Nikolaev. All rights reserved.
//

import UIKit

class LoaderView: UIView {

    fileprivate enum LoaderViewAnimationState {
        case invisible
        case fadingIn
        case fadingOut
        case fullyVisible
    }

    fileprivate struct InnerConstants {
        static let fadInOutDuration = 0.3

        static let kFadeInAnimationKey = "com.myapplication.fadeinanimationkey"
        static let kFadeOutAnimationKey = "com.myapplication.fadeoutanimationkey"
    }

    var spinnerImageView: UIImageView!

    fileprivate var animationState = LoaderViewAnimationState.invisible

    fileprivate lazy var fadeInAnimationObject = LoaderView.createFadeInAnimationObject()
    fileprivate lazy var fadeOutAnimationObject = LoaderView.createFadeOutAnimationObject()

    fileprivate class var sharedInstance: LoaderView {
        struct Singleton {
            static let instance = LoaderView(frame: CGRect(x: .zero, y: .zero, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        }
        return Singleton.instance
    }

    // MARK: - Initializer

    fileprivate override init(frame: CGRect) {

        super.init(frame: frame)

        backgroundColor = UIColor.white.withAlphaComponent(0.70)

        spinnerImageView = UIImageView()
        spinnerImageView.image = UIImage(named: "loading-overlay-spinner")?.withRenderingMode(.alwaysTemplate)
        spinnerImageView.contentMode = .scaleToFill
        spinnerImageView.tintColor = .gray

        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.fromValue = 0
        animation.toValue = .pi * 2.0
        animation.duration = 2
        animation.repeatCount = .infinity
        animation.isRemovedOnCompletion = false
        spinnerImageView.layer.add(animation, forKey: "spin")

        addSubview(spinnerImageView)

        spinnerImageView.autoAlignAxis(toSuperviewAxis: .vertical)
        spinnerImageView.autoAlignAxis(toSuperviewAxis: .horizontal)
    }

     class func setCustomLoaderTint(color: UIColor) {
        LoaderView.sharedInstance
            .spinnerImageView.tintColor = color
    }

     class func resetDefaultLoaderTint() {
        LoaderView.sharedInstance
            .spinnerImageView.tintColor = .gray
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

     class func show(_ view: UIView) {
        let progress = LoaderView.sharedInstance

        guard let window = view.window else {
            return
        }

        switch progress.animationState {
        case LoaderViewAnimationState.invisible:
            break
        default:
            return
        }

        progress.alpha = .zero
        window.addSubview(progress)
        window.layoutSubviews()
        progress.layoutSubviews()
        DispatchQueue.main.async {
            CATransaction.begin()
            CATransaction.setCompletionBlock {
                let presentationOpacity = progress.layer.presentation()?.value(forKeyPath: "opacity") as? CGFloat
                progress.alpha = presentationOpacity ?? 1
                progress.layer.removeAnimation(forKey: InnerConstants.kFadeInAnimationKey)
                progress.animationState = .fullyVisible
            }
            progress.layer.add(progress.fadeInAnimationObject, forKey: InnerConstants.kFadeInAnimationKey)
            progress.animationState = .fadingIn
            CATransaction.commit()
        }
    }

     class func hide(_ completion: (() -> Void)? = nil) {
        let progress = LoaderView.sharedInstance
        switch progress.animationState {
        case .invisible, .fadingOut:
            completion?()
            return
        case .fadingIn:
            progress.layer.removeAnimation(forKey: InnerConstants.kFadeInAnimationKey)
        case .fullyVisible:
            break
        }

        CATransaction.begin()
        CATransaction.setCompletionBlock {
            let presentationOpacity = progress.layer.presentation()?.value(forKeyPath: "opacity") as? CGFloat
            progress.alpha = presentationOpacity ?? 0
            progress.removeFromSuperview()
            progress.animationState = .invisible
            progress.layer.removeAnimation(forKey: InnerConstants.kFadeOutAnimationKey)
            completion?()
        }
        progress.layer.add(progress.fadeOutAnimationObject, forKey: InnerConstants.kFadeOutAnimationKey)
        progress.animationState = .fadingOut
        CATransaction.commit()
    }
}

// MARK: - CABasicAnimation objects

fileprivate extension LoaderView {
    static func createFadeInAnimationObject() -> CABasicAnimation {
        let fadeIn = CABasicAnimation(keyPath: "opacity")
        fadeIn.toValue = 1.0
        fadeIn.duration = InnerConstants.fadInOutDuration
        fadeIn.setValue("video", forKey: "fadeOut")
        fadeIn.repeatCount = 1.0
        fadeIn.fillMode = CAMediaTimingFillMode.forwards
        fadeIn.isRemovedOnCompletion = false
        return fadeIn
    }

    static func createFadeOutAnimationObject() -> CABasicAnimation {
        let fadeOut = CABasicAnimation(keyPath: "opacity")
        fadeOut.toValue = 0.0
        fadeOut.duration = InnerConstants.fadInOutDuration
        fadeOut.setValue("video", forKey: "fadeOut")
        fadeOut.repeatCount = 1.0
        fadeOut.fillMode = CAMediaTimingFillMode.forwards
        fadeOut.isRemovedOnCompletion = false
        return fadeOut
    }
}
