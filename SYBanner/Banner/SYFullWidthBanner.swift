//
//  SYFullWidthBanner.swift
//  SYBanner
//
//  Created by Emre Armagan on 03.01.25.
//  Copyright © 2025 Emre Armagan. All rights reserved.
//

/// A specialized banner that spans the full width of its container and dynamically adjusts its height based on its content.
///
/// `SYFullWidthBanner` is a subclass of `SYBanner` and overrides the `preferredContentSize` method to ensure
/// the banner takes the full width of its parent view while allowing its height to grow dynamically to fit its content.
///
/// Example Usage:
/// ```swift
/// let banner = SYFullWidthBanner("Dynamic Banner", "This banner dynamically adjusts its height based on the content.")
/// banner.present()
/// ```
public class SYFullWidthBanner: SYBanner {
    override public func preferredContentSize() -> CGSize {
        return systemLayoutSizeFitting(preferredContainerSize,
                                       withHorizontalFittingPriority: .required,
                                       verticalFittingPriority: .fittingSizeLevel)
    }
}
