//
//  Notifly+Configuration.swift
//  Notifly
//
//  Created by Emre Armagan on 04.01.25.
//  Copyright © 2025 Emre Armagan. All rights reserved.
//

import UIKit

extension Notifly {
    /// Defines the configuration for `Notifly`, allowing customization of text, colors, and icon.
    ///
    /// The configuration provides a centralized way to customize the appearance and behavior of notifications,
    /// including text styles, background colors, icons, alignments, and corner radius.
    public struct Configuration {
        public static let `default` = Configuration()

        /// The color of the title text.
        public var titleColor: UIColor

        /// The font of the title text.
        public var titleFont: UIFont

        /// The color of the subtitle text.
        public var subtitleColor: UIColor

        /// The font of the subtitle text.
        public var subtitleFont: UIFont

        /// The background color of the notification.
        public var backgroundColor: NotiflyBackgroundView.BackgroundColor

        /// The icon source for the notification, which defines the image, size, and tint color.
        public var icon: IconSource?

        /// The corner radius style for the notification.
        public var cornerRadius: NotiflyBackgroundView.CornerRadius

        /// The alignment for the text content within the notification.
        public var textAlignment: UIStackView.Alignment

        /// The alignment for the overall content within the notification.
        public var contentAlignment: UIStackView.Alignment

        /// The padding between the image and the text content.
        public var imagePadding: CGFloat

        /// The spacing between the title and subtitle text.
        public var titleSubtitleSpacing: CGFloat

        public init(
            titleColor: UIColor = .label,
            titleFont: UIFont = .systemFont(ofSize: 17, weight: .medium),
            subtitleColor: UIColor = .secondaryLabel,
            subtitleFont: UIFont = .systemFont(ofSize: 14, weight: .regular),
            backgroundColor: NotiflyBackgroundView.BackgroundColor = .default(.notiflyDefaultColor),
            icon: IconSource? = nil,
            cornerRadius: NotiflyBackgroundView.CornerRadius = .rounded,
            textAlignment: UIStackView.Alignment = .center,
            contentAlignment: UIStackView.Alignment = .center,
            imagePadding: CGFloat = 8,
            titleSubtitleSpacing: CGFloat = 0
        ) {
            self.titleColor = titleColor
            self.titleFont = titleFont
            self.subtitleColor = subtitleColor
            self.subtitleFont = subtitleFont
            self.backgroundColor = backgroundColor
            self.icon = icon
            self.cornerRadius = cornerRadius
            self.textAlignment = textAlignment
            self.contentAlignment = contentAlignment
            self.imagePadding = imagePadding
            self.titleSubtitleSpacing = titleSubtitleSpacing
        }
    }
}

extension Notifly.Configuration {
    /// Creates a configuration for informational notifications.
    public static func info() -> Notifly.Configuration {
        Notifly.Configuration(
            titleColor: .white,
            subtitleColor: .white,
            subtitleFont: .systemFont(ofSize: 14),
            backgroundColor: .default(UIColor(red: 85 / 255, green: 159 / 255, blue: 255 / 255, alpha: 1)),
            icon: Notifly.IconSource(image: UIImage(systemName: "info.circle.fill"), tintColor: .white),
            cornerRadius: .radius(10),
            textAlignment: .leading,
            contentAlignment: .center
        )
    }

    /// Creates a configuration for success notifications.
    public static func success() -> Notifly.Configuration {
        Notifly.Configuration(
            titleColor: .white,
            subtitleColor: .white,
            subtitleFont: .systemFont(ofSize: 14),
            backgroundColor: .default(UIColor(red: 42 / 255, green: 187 / 255, blue: 143 / 255, alpha: 1)),
            icon: Notifly.IconSource(image: UIImage(systemName: "checkmark.circle.fill"), tintColor: .white),
            cornerRadius: .radius(10),
            textAlignment: .leading,
            contentAlignment: .center
        )
    }

    /// Creates a configuration for warning notifications.
    public static func warning() -> Notifly.Configuration {
        Notifly.Configuration(
            titleColor: .white,
            subtitleColor: .white,
            subtitleFont: .systemFont(ofSize: 14),
            backgroundColor: .default(UIColor(red: 216 / 255, green: 92 / 255, blue: 90 / 255, alpha: 1)),
            icon: Notifly.IconSource(image: UIImage(systemName: "exclamationmark.circle.fill"), tintColor: .white),
            cornerRadius: .radius(10),
            textAlignment: .leading,
            contentAlignment: .center
        )
    }
}
