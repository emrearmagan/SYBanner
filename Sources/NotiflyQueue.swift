//
//  NotiflyQueue.swift
//  Notifly
//
//  Created by Emre Armagan on 06.04.22.
//

import Foundation

/// Manages a queue of notifications, ensuring proper handling of presentation and dismissal.
/// Supports controlling the maximum number of notifications visible on the screen simultaneously.
open class NotiflyQueue: NSObject {
    /// Defines the position in the queue where a notification should be added.
    public enum QueuePosition: Int {
        /// Add the notification to the back of the queue.
        case back
        /// Add the notification to the front of the queue.
        case front
    }

    // MARK: - Properties

    /// The default shared queue instance.
    public static let `default` = NotiflyQueue()

    /// All notifications currently in the queue.
    private(set) var notifications: [NotiflyBase] = []

    /// Notifications that are currently being presented or being presented.
    public var presentedNotifications: [NotiflyBase] {
        return notifications.filter { $0.presentationState == .presented || $0.presentationState == .presenting }
    }

    /// The maximum number of notifications that can be visible on the screen simultaneously.
    public var maxNotificationsOnScreenSimultaneously: Int = 1

    /// The total number of notifications currently in the queue.
    public var numberOfNotifications: Int {
        notifications.count
    }

    // MARK: Init

    /// Initializes a new instance of `NotiflyQueue`.
    ///
    /// - Parameter maxNotificationsOnScreen: The maximum number of notifications visible at once.
    public init(maxNotificationsOnScreen: Int = 1) {
        maxNotificationsOnScreenSimultaneously = maxNotificationsOnScreen
    }

    // MARK: - Queue Management

    /// Adds a notification to the queue at the specified position.
    ///
    /// - Parameters:
    ///   - notification: The notification to be added to the queue.
    ///   - queuePosition: The position in the queue where the notification should be added.
    open func addNotification(_ notification: NotiflyBase, queuePosition: QueuePosition) {
        // Ensure the notification is not already in the queue.
        removeNotification(notification, showNextInQueue: false)

        let currentNotificationsCount = notifications.filter { $0.presentationState == .presented || $0.presentationState == .presenting }.count
        let maxNotificationsCapped = currentNotificationsCount >= maxNotificationsOnScreenSimultaneously

        if queuePosition == .back {
            notifications.append(notification)

            if !maxNotificationsCapped {
                notification.present(placeOnQueue: false)
            }
        } else {
            if maxNotificationsCapped {
                if let firstDisplayed = firstDisplayedNotification() {
                    firstDisplayed.dismiss(showNext: false)
                }
            }
            notifications.insert(notification, at: 0)
            notification.present(placeOnQueue: false)
            layoutPresentedNotificationsIfNeeded(notification)
        }
    }

    /// Removes a notification from the queue and optionally shows the next notification in the queue.
    ///
    /// - Parameters:
    ///   - notification: The notification to be removed.
    ///   - showNextInQueue: Whether to show the next notification in the queue after removal. Defaults to `true`.
    open func removeNotification(_ notification: NotiflyBase, showNextInQueue: Bool = true) {
        if let index = notifications.firstIndex(of: notification) {
            notifications.remove(at: index)
        }

        if showNextInQueue {
            layoutPresentedNotificationsIfNeeded()
            showNext()
        }
    }

    /// Repositions all currently presented notifications.
    open func layoutPresentedNotificationsIfNeeded(_ exclude: NotiflyBase? = nil) {
        // Instead of reusing the `present(placeOnQueue: false)` function, we directly adjust positions to ensure consistent animations
        // across all notifications without triggering additional presentation logic or animations.
        for notification in presentedNotifications.filter({ $0 != exclude }) {
            if let superview = notification.superview {
                notification.presenter.adjustPosition(for: notification, in: superview)
            }
        }
    }

    /// Dismisses all notifications in the queue and clears the queue.
    open func dismissAll() {
        presentedNotifications.forEach { $0.dismiss(showNext: false) }
        notifications.removeAll()
    }

    /// Shows the next notification in the queue, if available.
    private func showNext() {
        if let notification = firstNotDisplayedNotification() {
            notification.present()
        }
    }

    /// Returns the first notification that is currently being displayed.
    ///
    /// - Returns: The first displayed notification, if any.
    public func firstDisplayedNotification() -> NotiflyBase? {
        notifications.filter { $0.presentationState == .presented || $0.presentationState == .presenting }.first
    }

    /// Returns the first notification in the queue that is not currently displayed.
    ///
    /// - Returns: The first non-displayed notification, if any.
    public func firstNotDisplayedNotification() -> NotiflyBase? {
        return notifications.filter { $0.presentationState == .idle }.first
    }
}
