//
//  SYBannerHighlighter.swift
//  SYBanner
//
//  Created by Emre Armagan on 04.01.25.
//  Copyright © 2025 Emre Armagan. All rights reserved.
//

import Foundation
import UIKit

/// A protocol that defines the behavior for highlighting a banner.
/// Conforming types can implement custom animations and behaviors when a banner is highlighted,
/// when the highlight is stopped, or when the touch location moves within the banner's bounds.
public protocol SYBannerHighlighter {
    /// Highlights the banner, typically in response to a touch interaction.
    ///
    /// - Parameters:
    ///   - button: The banner to highlight.
    ///   - location: The touch location triggering the highlight.
    func highlight(_ button: SYBaseBanner, at location: CGPoint)

    /// Stops highlighting the banner.
    ///
    /// - Parameter button: The banner to stop highlighting.
    func stopHighlight(_ button: SYBaseBanner)

    /// Handles changes in the touch location to update the highlight state.
    ///
    /// - Parameters:
    ///   - button: The banner being interacted with.
    ///   - location: The touch location to track.
    func locationMoved(_ button: SYBaseBanner, to location: CGPoint)
}

extension SYBannerHighlighter {
    /// Provides a default implementation for `locationMoved(_:)`.
    ///
    /// This method does nothing unless overridden by a conforming type.
    public func locationMoved(_ button: SYBaseBanner, to location: CGPoint) {}
}
