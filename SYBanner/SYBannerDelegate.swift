//
//  SYBannerDelegate.swift
//  SYBanner
//
//  Created by Emre Armagan on 06.04.22.
//

import Foundation

@objc
public protocol SYBannerDelegate: AnyObject {
    @objc optional func notificationBannerWillAppear(_ banner: SYBaseBanner)
    @objc optional func notificationBannerDidAppear(_ banner: SYBaseBanner)
    @objc optional func notificationBannerWillDisappear(_ banner: SYBaseBanner)
    @objc optional func notificationBannerDidDisappear(_ banner: SYBaseBanner)
}
