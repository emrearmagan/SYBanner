//
//  SYBouncePresenter.swift
//  SYBanner
//
//  Created by Emre Armagan on 03.01.25.
//  Copyright © 2025 Emre Armagan. All rights reserved.
//

import Foundation
import UIKit

/// A presenter that adds a "bounce" effect to the presentation animation.
///
/// - The presentation animation uses a spring effect for a more dynamic appearance.
/// - The dismissal animation uses a `.easeOut` curve for smoother disappearance.
public final class SYBouncePresenter: SYDefaultPresenter {
    override public func presentationAnimator(_ banner: SYBaseBanner, in superview: UIView) -> UIViewPropertyAnimator {
        let animator = UIViewPropertyAnimator(
            duration: animationDuration,
            timingParameters: UISpringTimingParameters(dampingRatio: 0.5, initialVelocity: CGVector(dx: 1.0, dy: 0.0))
        )

        animator.addAnimations { [weak self, banner] in
            guard let self = self else { return }
            banner.frame = self.finalFrame(for: banner, in: superview)
        }

        return animator
    }

    override public func dismissAnimator(_ banner: SYBaseBanner, in superview: UIView) -> UIViewPropertyAnimator {
        let animator = UIViewPropertyAnimator(duration: animationDuration, curve: .easeOut) { [weak self] in
            guard let self = self else { return }
            let initialRect = initialFrame(for: banner, in: superview)
            let offset = self.offsetForBanners(banner: banner, direction: banner.direction)

            switch banner.direction {
                case .top:
                    banner.frame.origin.y = initialRect.origin.y - offset

                case .bottom:
                    banner.frame.origin.y = initialRect.origin.y + offset
            }
        }

        return animator
    }
}
