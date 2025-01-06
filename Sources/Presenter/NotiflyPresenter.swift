//
//  NotiflyPresenter.swift
//  Notifly
//
//  Created by Emre Armagan on 03.01.25.
//  Copyright © 2025 Emre Armagan. All rights reserved.
//

import UIKit

/// A protocol defining the basic requirements for a notification presenter.
/// A notification presenter manages the animation and lifecycle of notifications during presentation and dismissal.
public protocol NotiflyPresenter {
    /// Duration of the animation for presenting and dismissing notifications.
    var animationDuration: TimeInterval { get set }

    /// The current state of the notification during its lifecycle.
    var state: NotiflyState { get }

    /// Required initializer for all notification presenters.
    init(animationDuration: TimeInterval)

    /// Presents the notification in the specified view.
    ///
    /// - Parameters:
    ///   - notification: The notification to present.
    ///   - view: The parent view where the notification will be added.
    ///   - completion: A closure called when the presentation animation is complete.
    @MainActor
    func present(notification: NotiflyBase, in view: UIView, completion: (() -> Void)?)

    /// Dismisses the notification from its parent view.
    ///
    /// - Parameters:
    ///   - notification: The notification to dismiss.
    ///   - completion: A closure called when the dismissal animation is complete.
    @MainActor
    func dismiss(notification: NotiflyBase, in view: UIView, completion: (() -> Void)?)

    /// Cancels any ongoing animations for the notification.
    func cancel()
}

public extension NotiflyPresenter {
    func adjustPosition(for notification: NotiflyBase, in superview: UIView) {
        // Adjusts the position of a notification within its superview.
        // Instead of triggering the full presentation logic, we directly update the notification's frame
        // to ensure consistent animations and avoid re-triggering any presentation side effects.
        guard notification.presentationState == .presented || notification.presentationState == .presenting else { return }

        cancel()
        UIView.animate(withDuration: 0.3) {
            notification.frame = finalFrame(for: notification, in: superview)
        }
    }

    /// Provides a default implementation for calculating the final frame of a notification.
    ///
    /// - Parameters:
    ///   - notification: The notification for which the frame is calculated.
    ///   - superview: The superview where the notification will be displayed.
    /// - Returns: The final frame of the notification.
    func finalFrame(for notification: NotiflyBase, in superview: UIView) -> CGRect {
        var rect = notification.frame
        rect.origin.x = (superview.frame.width - rect.width) / 2
        let offset = offsetForNotifications(notification: notification, direction: notification.direction)

        switch notification.direction {
            case .top:
                rect.origin.y = notification.notificationInsets.top + offset

            case .bottom:
                rect.origin.y = superview.frame.height
                    - notification.frame.size.height
                    - notification.notificationInsets.bottom
                    - offset
        }

        return rect
    }

    /// Provides a default implementation for calculating the initial frame of a notification.
    ///
    /// - Parameters:
    ///   - notification: The notification for which the frame is calculated.
    ///   - superview: The superview where the notification will be displayed.
    /// - Returns: The initial frame of the notification.
    func initialFrame(for notification: NotiflyBase, in superview: UIView) -> CGRect {
        var rect = notification.frame
        rect.origin.x = (superview.frame.width - rect.width) / 2

        switch notification.direction {
            case .top:
                rect.origin.y = -(
                    notification.frame.size.height
                        + notification.notificationInsets.top
                )

            case .bottom:
                rect.origin.y = superview.frame.height
                    + notification.notificationInsets.bottom
        }

        return rect
    }

    /// Calculates the offset for stacking notifications in the same direction.
    ///
    /// - Parameters:
    ///   - notification: The notification for which the offset is calculated.
    ///   - direction: The direction of the notifications (top or bottom).
    /// - Returns: The calculated offset.
    func offsetForNotifications(notification: NotiflyBase, direction: NotiflyDirection) -> CGFloat {
        let notifications = notification.notificationQueue.notifications
            .filter { $0.direction == direction }.filter { $0.presentationState == .presented || $0.presentationState == .presenting }

        let index = notifications.firstIndex(of: notification) ?? notifications.count
        return notifications.prefix(index).reduce(0) { totalOffset, notification in
            totalOffset + notification.bounds.height + 8
        }
    }
}
