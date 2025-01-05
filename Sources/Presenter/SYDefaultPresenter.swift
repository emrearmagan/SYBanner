//
//  SYDefaultPresenter.swift
//  SYBanner
//
//  Created by Emre Armagan on 02.01.25.
//  Copyright © 2025 Emre Armagan. All rights reserved.
//

import Foundation
import UIKit

/// A default presenter for animating banners.
/// This presenter provides basic linear animations for presenting and dismissing banners.
///
/// By default:
/// - The presentation animation uses a `UIViewPropertyAnimator` with a `.linear` curve.
/// - The dismissal animation uses a `UIViewPropertyAnimator` with a `.linear` curve.
open class SYDefaultPresenter: SYBannerPresenter {
    public var animationDuration: TimeInterval
    public var state: SYBannerState = .idle

    /// Animator responsible for running animations.
    weak var animator: UIViewAnimating?

    /// Initializes a new instance of `SYDefaultPresenter`.
    ///
    /// - Parameter animationDuration: The duration of the animation, in seconds.
    public required init(animationDuration: TimeInterval = 0.3) {
        self.animationDuration = animationDuration
    }

    public func present(banner: SYBaseBanner, in view: UIView, completion: (() -> Void)?) {
        guard state == .idle || state == .dismissing else {
            completion?()
            return
        }

        cancel()
        if state == .idle {
            prepare(banner: banner, in: view)
        }

        state = .presenting

        presentBanner(banner, in: view) { [weak self] in
            self?.state = .presented
            completion?()
        }
    }

    public func dismiss(banner: SYBaseBanner, in view: UIView, completion: (() -> Void)?) {
        cancel()
        state = .dismissing

        dismissBanner(banner, in: view) { [weak self] in
            self?.state = .idle
            completion?()
        }
    }

    public func cancel() {
        animator?.stopAnimation(true)
        animator?.finishAnimation(at: .current)
    }

    /// Prepares the banner for presentation by setting its initial frame.
    ///
    /// - Parameters:
    ///   - banner: The banner to prepare.
    ///   - superview: The superview where the banner will be displayed.
    open func prepare(banner: SYBaseBanner, in superview: UIView) {
        banner.frame = initialFrame(for: banner, in: superview)
    }

    /// Creates an animator for the presentation animation.
    ///
    /// - Parameters:
    ///   - banner: The banner to animate.
    ///   - superview: The superview where the banner will be displayed.
    /// - Returns: A `UIViewPropertyAnimator` configured for the presentation.
    open func presentationAnimator(_ banner: SYBaseBanner, in superview: UIView) -> UIViewPropertyAnimator {
        let animator = UIViewPropertyAnimator(duration: animationDuration, curve: .linear)

        animator.addAnimations { [weak self, banner] in
            guard let self = self else { return }
            banner.frame = self.finalFrame(for: banner, in: superview)
        }

        return animator
    }

    /// Creates an animator for the dismissal animation.
    ///
    /// - Parameters:
    ///   - banner: The banner to animate.
    ///   - superview: The superview where the banner is displayed.
    /// - Returns: A `UIViewPropertyAnimator` configured for the dismissal.
    open func dismissAnimator(_ banner: SYBaseBanner, in superview: UIView) -> UIViewPropertyAnimator {
        let animator = UIViewPropertyAnimator(duration: animationDuration, curve: .linear) { [weak self] in
            guard let self = self else { return }
            let initialRect = initialFrame(for: banner, in: superview)
            let offset = self.offsetForBanners(banner: banner, direction: banner.direction)

            switch banner.direction {
                case .top:
                    banner.frame.origin.y = initialRect.origin.y

                case .bottom:
                    banner.frame.origin.y = initialRect.origin.y + offset
            }
        }

        return animator
    }
}

// MARK: - Animation Functions

extension SYDefaultPresenter {
    /// Runs the presentation animation.
    private func presentBanner(_ banner: SYBaseBanner, in superview: UIView, _ completion: (() -> Void)?) {
        let animator = presentationAnimator(banner, in: superview)
        animator.addCompletion { [weak self] _ in
            completion?()
            self?.animator = nil
        }

        self.animator = animator
        animator.startAnimation()
    }

    /// Runs the dismissal animation.
    private func dismissBanner(_ banner: SYBaseBanner, in superview: UIView, _ completion: (() -> Void)?) {
        let animator = dismissAnimator(banner, in: superview)

        animator.addCompletion { [weak self] _ in
            completion?()
            self?.animator = nil
        }

        self.animator = animator
        animator.startAnimation()
    }
}
