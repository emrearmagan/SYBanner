//
//  Notifly+IconSource.swift
//  Notifly
//
//  Created by Emre Armagan on 04.01.25.
//  Copyright © 2025 Emre Armagan. All rights reserved.
//

import UIKit

extension Notifly {
    /// `IconSource` defines the image and appearance properties for a notification's icon.
    public struct IconSource {
        /// The image to be displayed as the icon.
        public let image: UIImage?

        /// The size of the icon. Defaults to 30x30 points.
        public let size: CGSize

        /// The color to tint the icon. If `nil`, the icon will use its original colors.
        public let tintColor: UIColor?

        /// The placement of the icon relative to the text content.
        public let placement: Placement

        /// Initializes an `IconSource` with the specified image, size, and tint color.
        ///
        /// - Parameters:
        ///   - image: The image to be used as the icon.
        ///   - size: The size of the icon. Defaults to 30x30 points.
        ///   - tintColor: The color to tint the icon. Defaults to `nil`.
        ///   - placement: The placement of the icon. Defaults to `leading`.
        public init(image: UIImage?,
                    size: CGSize = CGSize(width: 30, height: 30),
                    tintColor: UIColor? = nil,
                    placement: Placement = .leading
        ) {
            self.image = image
            self.size = size
            self.tintColor = tintColor
            self.placement = placement
        }

        /// Initializes an empty `IconSource` with no image or tint color.
        public static var empty: IconSource {
            return IconSource(image: nil)
        }
    }
}

extension Notifly.IconSource {
    /// `Placement` defines the position of the icon.
    public enum Placement: CaseIterable {
        /// The icon is placed to the leading side (left in left-to-right languages) of the title.
        case leading

        /// The icon is placed to the trailing side (right in left-to-right languages) of the title.
        case trailing

        /// The icon is placed above the title.
        case top

        /// The icon is placed below the title.
        case bottom
    }
}
