//
//  SYBannerState.swift
//  SYBanner
//
//  Created by Emre Armagan on 02.01.25.
//  Copyright © 2025 Emre Armagan. All rights reserved.
//

/// Represents the various states a banner can be in during its lifecycle.
public enum SYBannerState: Equatable {
    /// The banner is ready to be presented but has not yet been displayed.
    /// This is the initial state before any animations are triggered.
    case idle

    /// The banner is currently being dismissed.
    /// During this state, the banner is transitioning out of the view hierarchy.
    case dismissing

    /// The banner is currently being presented.
    /// During this state, the banner is transitioning into the view hierarchy.
    case presenting

    /// The banner is fully visible and has been successfully presented.
    /// This state indicates that the presentation animation has completed.
    case presented
}
