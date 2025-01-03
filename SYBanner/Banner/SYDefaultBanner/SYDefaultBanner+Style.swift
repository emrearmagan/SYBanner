//
//  SYDefaultBanner+Style.swift
//  SYBanner
//
//  Created by Emre Armagan on 03.01.25.
//  Copyright © 2025 Emre Armagan. All rights reserved.
//

import UIKit

extension SYDefaultBanner {
    /// A predefined set of styles for `SYDefaultBanner`, each with a unique icon and background color.
    public enum SYBannerStyle: Int {
        /// An informational style banner, typically used for general information.
        case info

        /// A warning style banner, typically used for alerts or cautionary messages.
        case warning

        /// A success style banner, typically used for positive feedback or confirmation messages.
        case success

        /// The associated icon for the banner style.
        var image: UIImage? {
            switch self {
                case .info:
                    return UIImage(systemName: "info.circle.fill")
                case .warning:
                    return UIImage(systemName: "exclamationmark.circle.fill")
                case .success:
                    return UIImage(systemName: "checkmark.circle.fill")
            }
        }

        /// The associated color for the banner style.
        var color: UIColor {
            switch self {
                case .info:
                    return UIColor(red: 85/255, green: 159/255, blue: 255/255, alpha: 1) // Blue
                case .warning:
                    return UIColor(red: 216/255, green: 92/255, blue: 90/255, alpha: 1) // Red
                case .success:
                    return UIColor(red: 42/255, green: 187/255, blue: 143/255, alpha: 1) // Green
            }
        }
    }
}
