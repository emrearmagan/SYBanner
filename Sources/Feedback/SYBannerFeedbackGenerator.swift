//
//  SYBannerFeedbackGenerator.swift
//  SYBanner
//
//  Created by Emre Armagan on 04.01.25.
//  Copyright © 2025 Emre Armagan. All rights reserved.
//

/// Protocol for defining custom haptic feedback generators.
public protocol SYBannerFeedbackGenerator {
    /// Executes the custom feedback.
    func generateFeedback()
}
