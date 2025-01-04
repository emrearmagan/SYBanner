//
//  SYBanner+Configuration.swift
//  SYBanner
//
//  Created by Emre Armagan on 04.01.25.
//  Copyright © 2025 Emre Armagan. All rights reserved.
//

import UIKit

extension SYBanner {
    /// Defines the configuration for `SYDefaultBanner`, allowing customization of text, colors, and icon.
    ///
    /// The configuration provides a centralized way to customize the appearance and behavior of banners,
    /// including text styles, background colors, icons, alignments, and corner radius.
    public struct Configuration {
        /// The color of the title text.
        public var titleColor: UIColor

        /// The font of the title text.
        public var titleFont: UIFont

        /// The color of the subtitle text.
        public var subtitleColor: UIColor

        /// The font of the subtitle text.
        public var subtitleFont: UIFont

        /// The background color of the banner.
        public var backgroundColor: SYBannerBackgroundView.BackgroundColor

        /// The icon source for the banner, which defines the image, size, and tint color.
        public var icon: IconSource?

        /// The corner radius style for the banner.
        public var cornerRadius: SYBannerBackgroundView.CornerRadius

        /// The alignment for the text content within the banner.
        public var textAlignment: UIStackView.Alignment

        /// The alignment for the overall content within the banner.
        public var contentAlignment: UIStackView.Alignment

        /// The padding between the image and the text content.
        public var imagePadding: CGFloat

        /// The spacing between the title and subtitle text.
        public var titleSubtitleSpacing: CGFloat

        /// Default configuration with standard appearance settings.
        public static let `default` = Configuration(
            titleColor: .label,
            titleFont: .systemFont(ofSize: 17, weight: .bold),
            subtitleColor: .secondaryLabel,
            subtitleFont: .systemFont(ofSize: 14, weight: .regular),
            backgroundColor: .default(.syDefaultColor),
            icon: nil,
            cornerRadius: .rounded,
            textAlignment: .center,
            contentAlignment: .center,
            imagePadding: 4,
            titleSubtitleSpacing: 0
        )
    }
}

extension SYBanner.Configuration {
    /// Creates a configuration for informational banners.
    public static func info() -> SYBanner.Configuration {
        SYBanner.Configuration(
            titleColor: .white,
            titleFont: .systemFont(ofSize: 17, weight: .semibold),
            subtitleColor: .white,
            subtitleFont: .systemFont(ofSize: 14),
            backgroundColor: .default(UIColor(red: 85 / 255, green: 159 / 255, blue: 255 / 255, alpha: 1)),
            icon: SYBanner.IconSource(image: UIImage(systemName: "info.circle.fill"), tintColor: .white),
            cornerRadius: .rounded,
            textAlignment: .leading,
            contentAlignment: .top,
            imagePadding: 4,
            titleSubtitleSpacing: 0
        )
    }

    /// Creates a configuration for success banners.
    public static func success() -> SYBanner.Configuration {
        SYBanner.Configuration(
            titleColor: .white,
            titleFont: .systemFont(ofSize: 17, weight: .semibold),
            subtitleColor: .white,
            subtitleFont: .systemFont(ofSize: 14),
            backgroundColor: .default(UIColor(red: 42 / 255, green: 187 / 255, blue: 143 / 255, alpha: 1)),
            icon: SYBanner.IconSource(image: UIImage(systemName: "checkmark.circle.fill"), tintColor: .white),
            cornerRadius: .rounded,
            textAlignment: .leading,
            contentAlignment: .top,
            imagePadding: 4,
            titleSubtitleSpacing: 0
        )
    }

    /// Creates a configuration for warning banners.
    public static func warning() -> SYBanner.Configuration {
        SYBanner.Configuration(
            titleColor: .white,
            titleFont: .systemFont(ofSize: 17, weight: .semibold),
            subtitleColor: .white,
            subtitleFont: .systemFont(ofSize: 14),
            backgroundColor: .default(UIColor(red: 216 / 255, green: 92 / 255, blue: 90 / 255, alpha: 1)),
            icon: SYBanner.IconSource(image: UIImage(systemName: "exclamationmark.circle.fill"), tintColor: .white),
            cornerRadius: .rounded,
            textAlignment: .leading,
            contentAlignment: .top,
            imagePadding: 4,
            titleSubtitleSpacing: 0
        )
    }
}
