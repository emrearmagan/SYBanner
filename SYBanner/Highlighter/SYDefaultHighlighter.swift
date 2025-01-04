//
//  SYDefaultHighlighter.swift
//  SYBanner
//
//  Created by Emre Armagan on 04.01.25.
//  Copyright © 2025 Emre Armagan. All rights reserved.
//

import Foundation
import UIKit

/// A default implementation of the `SYBannerHighlighter` protocol.
/// `SYDefaultHighlighter` provides smooth animations for scaling and adjusting the alpha of a banner
/// when it is highlighted or interacted with.
///
/// This highlighter can optionally track touch locations within the banner's bounds.
public class SYDefaultHighlighter: SYBannerHighlighter {
    // MARK: Properties

    /// Determines whether the highlighter should track the touch location within the banner's bounds.
    public var tracklocation: Bool

    /// The scale factor applied to the banner when it is highlighted.
    ///
    /// - Default: `0.95`
    public var animationScale: CGFloat

    /// The duration of the scaling animation.
    ///
    /// - Default: `0.2`
    public var animationDuration: TimeInterval

    /// A flag to track whether the banner is currently highlighted.
    private var highlighted: Bool = false

    // MARK: Init

    /// Initializes a new `SYDefaultHighlighter` with default settings.
    ///
    /// - Defaults:
    ///   - `tracklocation`: `false`
    ///   - `animationScale`: `0.95`
    ///   - `animationDuration`: `0.2`
    ///   - `highlightedAlpha`: `0.8`
    public convenience init() {
        self.init(tracklocation: true,
                  animationScale: 0.95,
                  animationDuration: 0.2)
    }

    /// Initializes a new `SYDefaultHighlighter` with custom settings.
    ///
    /// - Parameters:
    ///   - tracklocation: Whether to track touch location within the banner's bounds.
    ///   - animationScale: The scale factor applied to the banner when highlighted.
    ///   - animationDuration: The duration of the scaling animation.
    ///   - highlightedAlpha: The alpha value applied to the banner when highlighted.
    public init(tracklocation: Bool, animationScale: CGFloat, animationDuration: TimeInterval) {
        self.tracklocation = tracklocation
        self.animationScale = animationScale
        self.animationDuration = animationDuration
    }

    // MARK: Methods

    public func highlight(_ button: SYBaseBanner, at location: CGPoint) {
        guard !highlighted else { return }

        highlighted = true

        UIView.animate(withDuration: animationDuration, animations: {
            button.transform = CGAffineTransform(scaleX: self.animationScale, y: self.animationScale)
        })
    }

    public func stopHighlight(_ button: SYBaseBanner) {
        guard highlighted else { return }

        highlighted = false

        UIView.animate(withDuration: animationDuration, animations: {
            button.transform = CGAffineTransform.identity
        })
    }

    public func locationMoved(_ button: SYBaseBanner, to location: CGPoint) {
        guard tracklocation else { return }

        if button.bounds.contains(location) {
            if !highlighted {
                highlight(button, at: location)
            }
        } else {
            if highlighted {
                stopHighlight(button)
            }
        }
    }
}
