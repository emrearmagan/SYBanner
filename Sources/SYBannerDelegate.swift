//
//  SYBannerDelegate.swift
//  SYBanner
//
//  Created by Emre Armagan on 06.04.22.
//

import Foundation

/// A protocol that defines the lifecycle events for banners.
/// Conforming types can implement these methods to respond to banners being presented or dismissed.
public protocol SYBannerDelegate: AnyObject {
    /// Called before the banner begins its appearance animation.
    ///
    /// - Parameter banner: The banner that is about to appear.
    func bannerWillAppear(_ banner: SYBaseBanner)

    /// Called after the banner has completed its appearance animation and is fully visible.
    ///
    /// - Parameter banner: The banner that has appeared.
    func bannerDidAppear(_ banner: SYBaseBanner)

    /// Called before the banner begins its dismissal animation.
    ///
    /// - Parameter banner: The banner that is about to disappear.
    func bannerWillDisappear(_ banner: SYBaseBanner)

    /// Called after the banner has completed its dismissal animation and is fully removed from view.
    ///
    /// - Parameter banner: The banner that has disappeared.
    func bannerDidDisappear(_ banner: SYBaseBanner)
}

public extension SYBannerDelegate {
    /// Default implementation of `bannerWillAppear`, which does nothing.
    func bannerWillAppear(_ banner: SYBaseBanner) {}

    /// Default implementation of `bannerDidAppear`, which does nothing.
    func bannerDidAppear(_ banner: SYBaseBanner) {}

    /// Default implementation of `bannerWillDisappear`, which does nothing.
    func bannerWillDisappear(_ banner: SYBaseBanner) {}

    /// Default implementation of `bannerDidDisappear`, which does nothing.
    func bannerDidDisappear(_ banner: SYBaseBanner) {}
}
