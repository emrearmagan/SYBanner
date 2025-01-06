//
//  NotiflyFeedbackGenerator.swift
//  Notifly
//
//  Created by Emre Armagan on 04.01.25.
//  Copyright © 2025 Emre Armagan. All rights reserved.
//

/// Protocol for defining custom haptic feedback generators.
public protocol NotiflyFeedbackGenerator {
    /// Executes the custom feedback.
    func generateFeedback()
}
