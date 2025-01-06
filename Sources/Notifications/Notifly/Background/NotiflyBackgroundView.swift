//
//  Notifly+BackgroundView.swift
//  Notifly
//
//  Created by Emre Armagan on 04.01.25.
//  Copyright © 2025 Emre Armagan. All rights reserved.
//

import UIKit

/// Manages the background appearance of the notification, supporting solid colors and gradients.
public class NotiflyBackgroundView: UIView {
    // MARK: Properties

    private var gradientLayer: GradientLayer?

    private var gradientColors: [UIColor]? {
        didSet {
            setupGradientBackground()
        }
    }

    /// The background color or gradient applied to the view.
    public var bgColor: BackgroundColor? {
        didSet {
            switch bgColor {
                case let .default(color):
                    backgroundColor = color

                case let .gradient(colors, direction):
                    backgroundColor = .clear
                    gradientDirection = direction
                    gradientColors = colors

                case nil:
                    backgroundColor = .clear
            }
        }
    }

    /// The corner radius style for the view.
    public var cornerRadius: CornerRadius = .radius(0) {
        didSet { setupBorder() }
    }

    /// The direction of the gradient.
    public var gradientDirection: GradientDirection = .leftToRight

    /// The gradient locations for the gradient layer.
    public var gradientLocations: [CGFloat]? {
        didSet { setupGradientBackground() }
    }

    override public var backgroundColor: UIColor? {
        didSet {
            gradientLayer?.removeFromSuperlayer()
            gradientLayer = nil
        }
    }

    // MARK: Lifecycle

    override public func layoutSubviews() {
        super.layoutSubviews()
        setupBorder()

        if let layer = gradientLayer {
            layer.frame = bounds
            layer.cornerRadius = self.layer.cornerRadius
        }
    }

    // MARK: Methods

    private func setupGradientBackground() {
        if gradientLayer == nil {
            let gradient = GradientLayer()
            gradient.bounds = frame
            layer.insertSublayer(gradient, at: 0)
            gradientLayer = gradient
        }

        gradientLayer?.gradientColors = gradientColors
        gradientLayer?.gradientDirection = gradientDirection
        gradientLayer?.gradientLocations = gradientLocations
    }

    private func setupBorder() {
        switch cornerRadius {
            case .rounded:
                layer.cornerRadius = 0.5 * frame.size.height
            case let .radius(value):
                layer.cornerRadius = value
        }
    }
}
