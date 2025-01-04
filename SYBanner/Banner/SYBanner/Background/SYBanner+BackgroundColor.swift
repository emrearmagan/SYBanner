//
//  SYBanner+BackgroundColor.swift
//  SYBanner
//
//  Created by Emre Armagan on 04.01.25.
//  Copyright © 2025 Emre Armagan. All rights reserved.
//

import UIKit

extension SYBannerBackgroundView {
    /// Defines the background color for the banner.
    public enum BackgroundColor {
        /// A solid color background.
        case `default`(UIColor)

        /// A gradient background with specified colors and direction.
        case gradient([UIColor], GradientDirection)
    }
}
