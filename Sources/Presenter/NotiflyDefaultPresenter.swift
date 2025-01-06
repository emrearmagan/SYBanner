//
//  NotiflyDefaultPresenter.swift
//  Notifly
//
//  Created by Emre Armagan on 02.01.25.
//  Copyright © 2025 Emre Armagan. All rights reserved.
//

import Foundation
import UIKit

/// A default presenter for animating notifications.
/// This presenter provides basic linear animations for presenting and dismissing notifications.
///
/// By default:
/// - The presentation animation uses a `UIViewPropertyAnimator` with a `.linear` curve.
/// - The dismissal animation uses a `UIViewPropertyAnimator` with a `.linear` curve.
open class NotiflyDefaultPresenter: NotiflyPresenter {
    public var animationDuration: TimeInterval
    public var state: NotiflyState = .idle

    /// Animator responsible for running animations.
    weak var animator: UIViewAnimating?

    /// Initializes a new instance of `NotiflyDefaultPresenter`.
    ///
    /// - Parameter animationDuration: The duration of the animation, in seconds.
    public required init(animationDuration: TimeInterval = 0.3) {
        self.animationDuration = animationDuration
    }

    public func present(notification: NotiflyBase, in view: UIView, completion: (() -> Void)?) {
        guard state == .idle || state == .dismissing else {
            completion?()
            return
        }

        cancel()
        if state == .idle {
            prepare(notification: notification, in: view)
        }

        state = .presenting

        presentNotification(notification, in: view) { [weak self] in
            self?.state = .presented
            completion?()
        }
    }

    public func dismiss(notification: NotiflyBase, in view: UIView, completion: (() -> Void)?) {
        cancel()
        state = .dismissing

        dismissNotification(notification, in: view) { [weak self] in
            self?.state = .idle
            completion?()
        }
    }

    public func cancel() {
        animator?.stopAnimation(true)
        animator?.finishAnimation(at: .current)
    }

    /// Prepares the notification for presentation by setting its initial frame.
    ///
    /// - Parameters:
    ///   - notification: The notification to prepare.
    ///   - superview: The superview where the notification will be displayed.
    open func prepare(notification: NotiflyBase, in superview: UIView) {
        notification.frame = initialFrame(for: notification, in: superview)
    }

    /// Creates an animator for the presentation animation.
    ///
    /// - Parameters:
    ///   - notification: The notification to animate.
    ///   - superview: The superview where the notification will be displayed.
    /// - Returns: A `UIViewPropertyAnimator` configured for the presentation.
    open func presentationAnimator(_ notification: NotiflyBase, in superview: UIView) -> UIViewPropertyAnimator {
        let animator = UIViewPropertyAnimator(duration: animationDuration, curve: .linear)

        animator.addAnimations { [weak self, notification] in
            guard let self = self else { return }
            notification.frame = self.finalFrame(for: notification, in: superview)
        }

        return animator
    }

    /// Creates an animator for the dismissal animation.
    ///
    /// - Parameters:
    ///   - notification: The notification to animate.
    ///   - superview: The superview where the notification is displayed.
    /// - Returns: A `UIViewPropertyAnimator` configured for the dismissal.
    open func dismissAnimator(_ notification: NotiflyBase, in superview: UIView) -> UIViewPropertyAnimator {
        let animator = UIViewPropertyAnimator(duration: animationDuration, curve: .linear) { [weak self] in
            guard let self = self else { return }
            let initialRect = initialFrame(for: notification, in: superview)
            let offset = self.offsetForNotifications(notification: notification, direction: notification.direction)

            switch notification.direction {
                case .top:
                    notification.frame.origin.y = initialRect.origin.y

                case .bottom:
                    notification.frame.origin.y = initialRect.origin.y + offset
            }
        }

        return animator
    }
}

// MARK: - Animation Functions

extension NotiflyDefaultPresenter {
    /// Runs the presentation animation.
    private func presentNotification(_ notification: NotiflyBase, in superview: UIView, _ completion: (() -> Void)?) {
        let animator = presentationAnimator(notification, in: superview)
        animator.addCompletion { [weak self] _ in
            completion?()
            self?.animator = nil
        }

        self.animator = animator
        animator.startAnimation()
    }

    /// Runs the dismissal animation.
    private func dismissNotification(_ notification: NotiflyBase, in superview: UIView, _ completion: (() -> Void)?) {
        let animator = dismissAnimator(notification, in: superview)

        animator.addCompletion { [weak self] _ in
            completion?()
            self?.animator = nil
        }

        self.animator = animator
        animator.startAnimation()
    }
}
