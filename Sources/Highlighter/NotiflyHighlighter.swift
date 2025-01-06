//
//  NotiflyHighlighter.swift
//  Notifly
//
//  Created by Emre Armagan on 04.01.25.
//  Copyright © 2025 Emre Armagan. All rights reserved.
//

import Foundation
import UIKit

/// A protocol that defines the behavior for highlighting a notification.
/// Conforming types can implement custom animations and behaviors when a notification is highlighted,
/// when the highlight is stopped, or when the touch location moves within the notification's bounds.
public protocol NotiflyHighlighter {
    /// Highlights the notification, typically in response to a touch interaction.
    ///
    /// - Parameters:
    ///   - notification: The notification to highlight.
    ///   - location: The touch location triggering the highlight.
    func highlight(_ notification: NotiflyBase, at location: CGPoint)

    /// Stops highlighting the notification.
    ///
    /// - Parameter notification: The notification to stop highlighting.
    func stopHighlight(_ notification: NotiflyBase)

    /// Handles changes in the touch location to update the highlight state.
    ///
    /// - Parameters:
    ///   - notification: The notification being interacted with.
    ///   - location: The touch location to track.
    func locationMoved(_ notification: NotiflyBase, to location: CGPoint)
}

extension NotiflyHighlighter {
    /// Provides a default implementation for `locationMoved(_:)`.
    ///
    /// This method does nothing unless overridden by a conforming type.
    public func locationMoved(_ notification: NotiflyBase, to location: CGPoint) {}
}
