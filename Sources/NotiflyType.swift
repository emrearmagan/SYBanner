//
//  NotiflyType.swift
//  Notifly
//
//  Created by Emre Armagan on 02.01.25.
//  Copyright © 2025 Emre Armagan. All rights reserved.
//

import UIKit

/// Defines the type of notification and its behavior on the screen.
public enum NotiflyType {
    /// A notification that is fixed to the edges of the screen without any padding or floating behavior.
    ///
    /// This type ensures the notification spans the full width of the screen and adheres directly to the screen edges.
    case stick

    /// A notification that floats on the screen with customizable insets and respects the device's safe area.
    ///
    /// Use this type for notifications that require specific spacing around their edges while ensuring they do not overlap
    /// the notch, home indicator, or other safe area boundaries.
    ///
    /// - Parameters:
    ///   - insets: The `UIEdgeInsets` defining the spacing around the notification.
    case float(UIEdgeInsets)

    /// A notification that floats on the screen with customizable insets, ignoring the device's safe area.
    ///
    /// Use this type for notifications that need to occupy specific positions on the screen, even overlapping
    /// areas such as the notch, home indicator, or other safe area boundaries.
    ///
    /// - Parameters:
    ///   - insets: The `UIEdgeInsets` defining the spacing around the notification.
    case ignoringSafeArea(UIEdgeInsets)
}
