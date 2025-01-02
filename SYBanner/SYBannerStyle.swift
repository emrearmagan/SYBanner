//
//  SYBannerStyle.swift
//  NotificationBanner
//
//  Created by Emre Armagan on 06.04.22.
//

import UIKit

public enum SYBannerStyle: Int {
    case none
    case info
    case warning
    case success

    var image: UIImage? {
        switch self {
            case .none:
                return nil
            case .info:
                return UIImage(systemName: "info.circle")
            case .warning:
                return UIImage(systemName: "exclamationmark.circle")
            case .success:
                return UIImage(systemName: "checkmark.circle")
        }
    }

    var color: UIColor {
        switch self {
            case .none:
                return .systemBackground
            case .info:
                return .lightGray
            case .warning:
                return UIColor(red: 216 / 255, green: 92 / 255, blue: 90 / 255, alpha: 1)
            case .success:
                return UIColor(red: 42 / 255, green: 187 / 255, blue: 172 / 255, alpha: 1)
        }
    }
}
