//
//  NotiflyDefaultHighlighter.swift
//  Notifly
//
//  Created by Emre Armagan on 04.01.25.
//  Copyright © 2025 Emre Armagan. All rights reserved.
//

import Foundation
import UIKit

/// A default implementation of the `NotiflyHighlighter` protocol.
/// `NotiflyDefaultHighlighter` provides smooth animations for scaling and adjusting the alpha of a notification
/// when it is highlighted or interacted with.
///
/// This highlighter can optionally track touch locations within the notification's bounds.
public class NotiflyDefaultHighlighter: NotiflyHighlighter {
    // MARK: Properties

    /// Determines whether the highlighter should track the touch location within the notification's bounds.
    public var tracklocation: Bool

    /// The scale factor applied to the notification when it is highlighted.
    ///
    /// - Default: `0.95`
    public var animationScale: CGFloat

    /// The duration of the scaling animation.
    ///
    /// - Default: `0.2`
    public var animationDuration: TimeInterval

    /// A flag to track whether the notification is currently highlighted.
    private var highlighted: Bool = false

    // MARK: Init

    /// Initializes a new `NotiflyDefaultHighlighter` with default settings.
    ///
    /// - Defaults:
    ///   - `tracklocation`: `false`
    ///   - `animationScale`: `0.98`
    ///   - `animationDuration`: `0.2`
    public convenience init() {
        self.init(tracklocation: true,
                  animationScale: 0.98,
                  animationDuration: 0.2)
    }

    /// Initializes a new `NotiflyDefaultHighlighter` with custom settings.
    ///
    /// - Parameters:
    ///   - tracklocation: Whether to track touch location within the notification's bounds.
    ///   - animationScale: The scale factor applied to the notification when highlighted.
    ///   - animationDuration: The duration of the scaling animation.
    public init(tracklocation: Bool, animationScale: CGFloat, animationDuration: TimeInterval) {
        self.tracklocation = tracklocation
        self.animationScale = animationScale
        self.animationDuration = animationDuration
    }

    // MARK: Methods

    public func highlight(_ notification: NotiflyBase, at location: CGPoint) {
        guard !highlighted else { return }

        highlighted = true

        UIView.animate(withDuration: animationDuration, animations: {
            notification.transform = CGAffineTransform(scaleX: self.animationScale, y: self.animationScale)
        })
    }

    public func stopHighlight(_ notification: NotiflyBase) {
        guard highlighted else { return }

        highlighted = false

        UIView.animate(withDuration: animationDuration, animations: {
            notification.transform = CGAffineTransform.identity
        })
    }

    public func locationMoved(_ notification: NotiflyBase, to location: CGPoint) {
        guard tracklocation else { return }

        if notification.bounds.contains(location) {
            if !highlighted {
                highlight(notification, at: location)
            }
        } else {
            if highlighted {
                stopHighlight(notification)
            }
        }
    }
}
