//
//  NotiflyScalePresenter.swift
//  Notifly
//
//  Created by Emre Armagan on 04.01.25.
//  Copyright © 2025 Emre Armagan. All rights reserved.
//

import UIKit

/// A presenter that adds a "scale" effect to the presentation animation.
public final class NotiflyScalePresenter: NotiflyDefaultPresenter {
    private let transform = CGAffineTransform(scaleX: 0, y: 0)

    override public func prepare(notification: NotiflyBase, in superview: UIView) {
        notification.frame = finalFrame(for: notification, in: superview)
        notification.transform = transform
    }

    override public func presentationAnimator(_ notification: NotiflyBase, in superview: UIView) -> UIViewPropertyAnimator {
        let animator = UIViewPropertyAnimator(duration: animationDuration, curve: .easeInOut)
        animator.addAnimations { [weak self, notification] in
            guard let self = self else { return }
            notification.transform = .identity
            notification.frame = self.finalFrame(for: notification, in: superview)
        }

        return animator
    }

    override public func dismissAnimator(_ notification: NotiflyBase, in superview: UIView) -> UIViewPropertyAnimator {
        let animator = UIViewPropertyAnimator(duration: animationDuration, curve: .easeOut) { [weak self] in
            guard let self = self else { return }
            notification.frame = self.finalFrame(for: notification, in: superview)
            notification.transform = self.transform
        }

        return animator
    }
}
