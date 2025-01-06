//
//  NotiflyFadePresenter.swift
//  Notifly
//
//  Created by Emre Armagan on 03.01.25.
//  Copyright © 2025 Emre Armagan. All rights reserved.
//

import Foundation
import UIKit

/// A presenter that handles fade-in and fade-out animations for notifications.
/// The notification smoothly transitions its alpha from 0 to 1 during presentation
/// and from 1 to 0 during dismissal.
public final class NotiflyFadePresenter: NotiflyDefaultPresenter {
    override public func prepare(notification: NotiflyBase, in superview: UIView) {
        notification.frame = finalFrame(for: notification, in: superview)
        notification.alpha = 0
    }

    override public func presentationAnimator(_ notification: NotiflyBase, in superview: UIView) -> UIViewPropertyAnimator {
        let animator = UIViewPropertyAnimator(duration: animationDuration, curve: .easeOut)
        animator.addAnimations { [weak self] in
            guard let self = self else { return }
            notification.frame = self.finalFrame(for: notification, in: superview)
            notification.alpha = 1
        }

        return animator
    }

    override public func dismissAnimator(_ notification: NotiflyBase, in superview: UIView) -> UIViewPropertyAnimator {
        let animator = UIViewPropertyAnimator(duration: animationDuration, curve: .linear)
        animator.addAnimations {
            notification.alpha = 0
        }

        return animator
    }
}
