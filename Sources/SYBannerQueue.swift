//
//  SYBannerQueue.swift
//  SYBanner
//
//  Created by Emre Armagan on 06.04.22.
//

import Foundation

/// Manages a queue of banners, ensuring proper handling of presentation and dismissal.
/// Supports controlling the maximum number of banners visible on the screen simultaneously.
open class SYBannerQueue: NSObject {
    /// Defines the position in the queue where a banner should be added.
    public enum QueuePosition: Int {
        /// Add the banner to the back of the queue.
        case back
        /// Add the banner to the front of the queue.
        case front
    }

    // MARK: - Properties

    /// The default shared queue instance.
    public static let `default` = SYBannerQueue()

    /// All banners currently in the queue.
    private(set) var banners: [SYBaseBanner] = []

    /// Banners that are currently being presented or being presented.
    public var presentedBanners: [SYBaseBanner] {
        return banners.filter { $0.presentationState == .presented || $0.presentationState == .presenting }
    }

    /// The maximum number of banners that can be visible on the screen simultaneously.
    public var maxBannersOnScreenSimultaneously: Int = 1

    /// The total number of banners currently in the queue.
    public var numberOfBanners: Int {
        banners.count
    }

    // MARK: Init

    /// Initializes a new instance of `SYBannerQueue`.
    ///
    /// - Parameter maxBannersOnScreen: The maximum number of banners visible at once.
    public init(maxBannersOnScreen: Int = 1) {
        maxBannersOnScreenSimultaneously = maxBannersOnScreen
    }

    // MARK: - Queue Management

    /// Adds a banner to the queue at the specified position.
    ///
    /// - Parameters:
    ///   - banner: The banner to be added to the queue.
    ///   - queuePosition: The position in the queue where the banner should be added.
    open func addBanner(_ banner: SYBaseBanner, queuePosition: QueuePosition) {
        // Ensure the banner is not already in the queue.
        removeBanner(banner, showNextInQueue: false)

        let currentBannersCount = banners.filter { $0.presentationState == .presented || $0.presentationState == .presenting }.count
        let maxBannersCapped = currentBannersCount >= maxBannersOnScreenSimultaneously

        if queuePosition == .back {
            banners.append(banner)

            if !maxBannersCapped {
                banner.present(placeOnQueue: false)
            }
        } else {
            if maxBannersCapped {
                if let firstDisplayed = firstDisplayedBanner() {
                    firstDisplayed.dismiss(showNext: false)
                }
            }
            banners.insert(banner, at: 0)
            banner.present(placeOnQueue: false)
            layoutPresentedBannersIfNeeded(banner)
        }
    }

    /// Removes a banner from the queue and optionally shows the next banner in the queue.
    ///
    /// - Parameters:
    ///   - banner: The banner to be removed.
    ///   - showNextInQueue: Whether to show the next banner in the queue after removal. Defaults to `true`.
    open func removeBanner(_ banner: SYBaseBanner, showNextInQueue: Bool = true) {
        if let index = banners.firstIndex(of: banner) {
            banners.remove(at: index)
        }

        if showNextInQueue {
            layoutPresentedBannersIfNeeded()
            showNext()
        }
    }

    /// Repositions all currently presented banners.
    open func layoutPresentedBannersIfNeeded(_ exclude: SYBaseBanner? = nil) {
        // Instead of reusing the `present(placeOnQueue: false)` function, we directly adjust positions to ensure consistent animations
        // across all banners without triggering additional presentation logic or animations.
        for banner in presentedBanners.filter({ $0 != exclude }) {
            if let superview = banner.superview {
                banner.presenter.adjustPosition(for: banner, in: superview)
            }
        }
    }

    /// Dismisses all banners in the queue and clears the queue.
    open func dismissAll() {
        presentedBanners.forEach { $0.dismiss(showNext: false) }
        banners.removeAll()
    }

    /// Shows the next banner in the queue, if available.
    private func showNext() {
        if let banner = firstNotDisplayedBanner() {
            banner.present()
        }
    }

    /// Returns the first banner that is currently being displayed.
    ///
    /// - Returns: The first displayed banner, if any.
    public func firstDisplayedBanner() -> SYBaseBanner? {
        banners.filter { $0.presentationState == .presented || $0.presentationState == .presenting }.first
    }

    /// Returns the first banner in the queue that is not currently displayed.
    ///
    /// - Returns: The first non-displayed banner, if any.
    public func firstNotDisplayedBanner() -> SYBaseBanner? {
        return banners.filter { $0.presentationState == .idle }.first
    }
}
