//
//  SYBanner+GradientLayer.swift
//  SYBanner
//
//  Created by Emre Armagan on 04.01.25.
//  Copyright © 2025 Emre Armagan. All rights reserved.
//

import UIKit

extension SYBannerBackgroundView {
    class GradientLayer: CAGradientLayer {
        var gradientColors: [UIColor]? {
            didSet {
                colors = gradientColors?.map { $0.cgColor }
            }
        }

        var gradientLocations: [CGFloat]? {
            didSet {
                locations = gradientLocations?.map { NSNumber(value: Float($0)) }
            }
        }

        var gradientDirection: GradientDirection = .leftToRight {
            didSet {
                startPoint = gradientDirection.startPoint
                endPoint = gradientDirection.endPoint
            }
        }
    }
}
