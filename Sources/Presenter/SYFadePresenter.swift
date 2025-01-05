//
//  SYFadePresenter.swift
//  SYBanner
//
//  Created by Emre Armagan on 03.01.25.
//  Copyright © 2025 Emre Armagan. All rights reserved.
//

import Foundation
import UIKit

/// A presenter that handles fade-in and fade-out animations for banners.
/// The banner smoothly transitions its alpha from 0 to 1 during presentation
/// and from 1 to 0 during dismissal.
public final class SYFadePresenter: SYDefaultPresenter {
    override public func prepare(banner: SYBaseBanner, in superview: UIView) {
        banner.frame = finalFrame(for: banner, in: superview)
        banner.alpha = 0
    }

    override public func presentationAnimator(_ banner: SYBaseBanner, in superview: UIView) -> UIViewPropertyAnimator {
        let animator = UIViewPropertyAnimator(duration: animationDuration, curve: .easeOut)
        animator.addAnimations { [weak self] in
            guard let self = self else { return }
            banner.frame = self.finalFrame(for: banner, in: superview)
            banner.alpha = 1
        }

        return animator
    }

    override public func dismissAnimator(_ banner: SYBaseBanner, in superview: UIView) -> UIViewPropertyAnimator {
        let animator = UIViewPropertyAnimator(duration: animationDuration, curve: .linear)
        animator.addAnimations {
            banner.alpha = 0
        }

        return animator
    }
}
