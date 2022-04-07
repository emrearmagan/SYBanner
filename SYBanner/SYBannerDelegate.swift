//
//  SYBannerDelegate.swift
//  SYBanner
//
//  Created by Emre Armagan on 06.04.22.
//

import Foundation

public protocol SYBannerDelegate: AnyObject {
    func notificationBannerWillAppear(_ banner: SYBaseBanner)
    func notificationBannerDidAppear(_ banner: SYBaseBanner)
    func notificationBannerWillDisappear(_ banner: SYBaseBanner)
    func notificationBannerDidDisappear(_ banner: SYBaseBanner)
}
