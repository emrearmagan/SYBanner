//
//  NotiflyFullWidthNotification.swift
//  Notifly
//
//  Created by Emre Armagan on 03.01.25.
//  Copyright © 2025 Emre Armagan. All rights reserved.
//

import UIKit

/// A specialized notification that spans the full width of its container
///
/// `NotiflyFullWidthNotification` is a subclass of `Notifly` and overrides the
/// `preferredContentSize` method to ensure the notification takes the full width of its parent
///
/// Example Usage:
/// ```swift
/// let notification = NotiflyFullWidthNotification("Dynamic Notification")
/// notification.present()
/// ```
public class NotiflyFullWidthNotification: Notifly {
    override public func preferredContentSize() -> CGSize {
        return systemLayoutSizeFitting(preferredContainerSize,
                                       withHorizontalFittingPriority: .required,
                                       verticalFittingPriority: .fittingSizeLevel)
    }
}
