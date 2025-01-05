//
//  UIColor+SYBanner.swift
//  SYBanner
//
//  Created by Emre Armagan on 03.01.25.
//  Copyright © 2025 Emre Armagan. All rights reserved.
//

import UIKit

/// A collection of custom colors used in the SYBanner framework.
extension UIColor {
    /// The default color used for banners, adapting to the user's interface style.
    ///
    /// - Light mode: White
    /// - Dark mode: A dark gray color with RGB (26, 29, 33)
    ///
    /// Example:
    /// ```swift
    /// let bannerBackground = UIColor.syDefaultColor
    /// ```
    public static var syDefaultColor: UIColor {
        return UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
                case .dark:
                    return UIColor(red: 26/255, green: 29/255, blue: 33/255, alpha: 1.0)

                default:
                    return .white
            }
        }
    }
}
