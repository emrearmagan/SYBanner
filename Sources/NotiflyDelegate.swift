//
//  NotiflyDelegate.swift
//  Notifly
//
//  Created by Emre Armagan on 06.04.22.
//

import Foundation

/// A protocol that defines the lifecycle events for notifications.
/// Conforming types can implement these methods to respond to notifications being presented or dismissed.
public protocol NotiflyDelegate: AnyObject {
    /// Called before the notification begins its appearance animation.
    ///
    /// - Parameter notification: The notification that is about to appear.
    func notificationWillAppear(_ notification: NotiflyBase)

    /// Called after the notification has completed its appearance animation and is fully visible.
    ///
    /// - Parameter notification: The notification that has appeared.
    func notificationDidAppear(_ notification: NotiflyBase)

    /// Called before the notification begins its dismissal animation.
    ///
    /// - Parameter notification: The notification that is about to disappear.
    func notificationWillDisappear(_ notification: NotiflyBase)

    /// Called after the notification has completed its dismissal animation and is fully removed from view.
    ///
    /// - Parameter notification: The notification that has disappeared.
    func notificationDidDisappear(_ notification: NotiflyBase)
}

public extension NotiflyDelegate {
    /// Default implementation of `notificationWillAppear`, which does nothing.
    func notificationWillAppear(_ notification: NotiflyBase) {}

    /// Default implementation of `notificationDidAppear`, which does nothing.
    func notificationDidAppear(_ notification: NotiflyBase) {}

    /// Default implementation of `notificationWillDisappear`, which does nothing.
    func notificationWillDisappear(_ notification: NotiflyBase) {}

    /// Default implementation of `notificationDidDisappear`, which does nothing.
    func notificationDidDisappear(_ notification: NotiflyBase) {}
}
