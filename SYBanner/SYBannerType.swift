//
//  NotificationStatusType.swift
//  NotificationBanner
//
//  Created by Emre Armagan on 06.04.22.
//

import UIKit

public enum SYBannerType {
    case info
    case warning
    case success
    
    var image:UIImage? {
        switch self {
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
        case .info:
            return .lightGray
        case .warning:
            return UIColor.init(red: 216/255, green: 92/255, blue: 90/255, alpha: 1)
        case .success:
            return UIColor.init(red: 42/255, green: 187/255, blue: 172/255, alpha: 1)
        }
    }
}
