//
//  SYBannerPresenter.swift
//  SYBanner
//
//  Created by Emre Armagan on 03.01.25.
//  Copyright © 2025 Emre Armagan. All rights reserved.
//

import UIKit

/// A protocol defining the basic requirements for a banner presenter.
/// A banner presenter manages the animation and lifecycle of banners during presentation and dismissal.
public protocol SYBannerPresenter {
    /// Duration of the animation for presenting and dismissing banners.
    var animationDuration: CGFloat { get set }

    /// The current state of the banner during its lifecycle.
    var state: SYBannerState { get }

    /// Required initializer for all banner presenters.
    init(animationDuration: CGFloat)

    /// Presents the banner in the specified view.
    ///
    /// - Parameters:
    ///   - banner: The banner to present.
    ///   - view: The parent view where the banner will be added.
    ///   - completion: A closure called when the presentation animation is complete.
    @MainActor
    func present(banner: SYBaseBanner, in view: UIView, completion: (() -> Void)?)

    /// Dismisses the banner from its parent view.
    ///
    /// - Parameters:
    ///   - banner: The banner to dismiss.
    ///   - completion: A closure called when the dismissal animation is complete.
    @MainActor
    func dismiss(banner: SYBaseBanner, completion: (() -> Void)?)

    /// Cancels any ongoing animations for the banner.
    func cancel()
}

public extension SYBannerPresenter {
    /// Provides a default implementation for calculating the final frame of a banner.
    ///
    /// - Parameters:
    ///   - banner: The banner for which the frame is calculated.
    ///   - superview: The superview where the banner will be displayed.
    /// - Returns: The final frame of the banner.
    func finalFrame(for banner: SYBaseBanner, in superview: UIView) -> CGRect {
        var rect = banner.frame
        rect.origin.x = (superview.frame.width - rect.width) / 2
        let offset = offsetForBanners(banner: banner, direction: banner.direction)

        switch banner.direction {
            case .top:
                rect.origin.y = banner.bannerInsets.top + offset

            case .bottom:
                rect.origin.y = superview.frame.height
                    - banner.frame.size.height
                    - banner.bannerInsets.bottom
                    - offset
        }

        return rect
    }

    /// Provides a default implementation for calculating the initial frame of a banner.
    ///
    /// - Parameters:
    ///   - banner: The banner for which the frame is calculated.
    ///   - superview: The superview where the banner will be displayed.
    /// - Returns: The initial frame of the banner.
    func initialFrame(for banner: SYBaseBanner, in superview: UIView) -> CGRect {
        var rect = banner.frame
        rect.origin.x = (superview.frame.width - rect.width) / 2

        switch banner.direction {
            case .top:
                rect.origin.y = -(
                    banner.frame.size.height
                        + banner.bannerInsets.top
                )

            case .bottom:
                rect.origin.y = superview.frame.height
                    + banner.bannerInsets.bottom
        }

        return rect
    }

    /// Calculates the offset for stacking banners in the same direction.
    ///
    /// - Parameters:
    ///   - banner: The banner for which the offset is calculated.
    ///   - direction: The direction of the banners (top or bottom).
    /// - Returns: The calculated offset.
    func offsetForBanners(banner: SYBaseBanner, direction: SYBannerDirection) -> CGFloat {
        let banners = banner.bannerQueue.banners
            .filter { $0.direction == direction }.filter { $0.state == .presented || $0.state == .presenting }

        let index = banners.firstIndex(of: banner) ?? banners.count
        return banners.prefix(index).reduce(0) { totalOffset, banner in
            totalOffset + banner.bounds.height + 8
        }
    }
}
