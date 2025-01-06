//
//  NotiflyBackgroundView+CornerRadius.swift
//  Notifly
//
//  Created by Emre Armagan on 04.01.25.
//  Copyright © 2025 Emre Armagan. All rights reserved.
//

import Foundation

extension NotiflyBackgroundView {
    /// Defines the corner rounding behavior for the notification.
    public enum CornerRadius {
        /// Rounds the corners to create a capsule shape (based on the notification's height).
        case rounded

        /// Uses a specific numeric corner radius.
        ///
        /// - Parameter value: The radius value to apply to each corner.
        case radius(_ value: CGFloat)
    }
}
