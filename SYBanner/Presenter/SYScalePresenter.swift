//
//  SYScalePresenter.swift
//  SYBanner
//
//  Created by Emre Armagan on 04.01.25.
//  Copyright © 2025 Emre Armagan. All rights reserved.
//

import UIKit

/// A presenter that adds a "scale" effect to the presentation animation.
public final class SYScalePresenter: SYDefaultPresenter {
    private let transform = CGAffineTransform(scaleX: 0, y: 0)

    override public func prepare(banner: SYBaseBanner, in superview: UIView) {
        banner.frame = finalFrame(for: banner, in: superview)
        banner.transform = transform
    }

    override public func presentationAnimator(_ banner: SYBaseBanner, in superview: UIView) -> UIViewPropertyAnimator {
        let animator = UIViewPropertyAnimator(duration: animationDuration, curve: .easeInOut)
        animator.addAnimations { [weak self, banner] in
            guard let self = self else { return }
            banner.transform = .identity
            banner.frame = self.finalFrame(for: banner, in: superview)
        }

        return animator
    }

    override public func dismissAnimator(_ banner: SYBaseBanner, in superview: UIView) -> UIViewPropertyAnimator {
        let animator = UIViewPropertyAnimator(duration: animationDuration, curve: .easeOut) { [weak self] in
            guard let self = self else { return }
            banner.frame = self.finalFrame(for: banner, in: superview)
            banner.transform = self.transform
        }

        return animator
    }
}
