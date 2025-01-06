//
//  NotiflyBackgroundView+BackgroundColor.swift
//  Notifly
//
//  Created by Emre Armagan on 04.01.25.
//  Copyright © 2025 Emre Armagan. All rights reserved.
//

import UIKit

extension NotiflyBackgroundView {
    /// Defines the background color for the notification.
    public enum BackgroundColor {
        /// A solid color background.
        case `default`(UIColor)

        /// A gradient background with specified colors and direction.
        case gradient([UIColor], GradientDirection)
    }
}
