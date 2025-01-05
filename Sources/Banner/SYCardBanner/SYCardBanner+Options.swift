//
//  SYCardBanner+Options.swift
//  SYBanner
//
//  Created by Emre Armagan on 04.01.25.
//  Copyright © 2025 Emre Armagan. All rights reserved.
//

import UIKit

extension SYCardBanner {
    public enum Options {
        case backgroundColor(UIColor)
        case buttonsHeight(CGFloat)
        case cornerRounding(CGFloat)
        case titleFont(UIFont)
        case titleColor(UIColor)
        case subTitleFont(UIFont)
        case subTitleColor(UIColor)
        case subTitleSpacing(CGFloat)
        case customView(UIView)
        case customViewInsets(UIEdgeInsets)
        case contentInsets(UIEdgeInsets)
        case showExitButton(Bool)
        case buttonAxis(NSLayoutConstraint.Axis)
    }
}
