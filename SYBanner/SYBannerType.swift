//
//  SYBannerType.swift
//  SYBanner
//
//  Created by Emre Armagan on 02.01.25.
//  Copyright © 2025 Emre Armagan. All rights reserved.
//

import UIKit

/// Defines the type of banner and its behavior on the screen.
public enum SYBannerType {
    /// A banner that is fixed to the edges of the screen without any padding or floating behavior.
    ///
    /// This type ensures the banner spans the full width of the screen and adheres directly to the screen edges.
    case stick

    /// A banner that floats on the screen with customizable insets and respects the device's safe area.
    ///
    /// Use this type for banners that require specific spacing around their edges while ensuring they do not overlap
    /// the notch, home indicator, or other safe area boundaries.
    ///
    /// - Parameters:
    ///   - insets: The `UIEdgeInsets` defining the spacing around the banner.
    case float(UIEdgeInsets)

    /// A banner that floats on the screen with customizable insets, ignoring the device's safe area.
    ///
    /// Use this type for banners that need to occupy specific positions on the screen, even overlapping
    /// areas such as the notch, home indicator, or other safe area boundaries.
    ///
    /// - Parameters:
    ///   - insets: The `UIEdgeInsets` defining the spacing around the banner.
    case ignoringSafeArea(UIEdgeInsets)
}
