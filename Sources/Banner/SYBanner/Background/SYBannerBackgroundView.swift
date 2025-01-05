//
//  SYBanner+BackgroundView.swift
//  SYBanner
//
//  Created by Emre Armagan on 04.01.25.
//  Copyright © 2025 Emre Armagan. All rights reserved.
//

import UIKit

/// Manages the background appearance of the banner, supporting solid colors and gradients.
public class SYBannerBackgroundView: UIView {
    // MARK: Properties

    private var gradienLayer: GradientLayer?

    private var gradientColors: [UIColor]? {
        didSet {
            setupGradientBackground()
        }
    }

    /// The background color or gradient applied to the view
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
            gradienLayer?.removeFromSuperlayer()
            gradienLayer = nil
        }
    }

    // MARK: Lifecycle

    override public func layoutSubviews() {
        super.layoutSubviews()
        setupBorder()

        if let layer = gradienLayer {
            layer.frame = bounds
            layer.cornerRadius = self.layer.cornerRadius
        }
    }

    // MARK: Methods

    private func setupGradientBackground() {
        if gradienLayer == nil {
            let gradient = GradientLayer()
            gradient.bounds = frame
            layer.insertSublayer(gradient, at: 0)
            gradienLayer = gradient
        }

        gradienLayer?.gradientColors = gradientColors
        gradienLayer?.gradientDirection = gradientDirection
        gradienLayer?.gradientLocations = gradientLocations
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
