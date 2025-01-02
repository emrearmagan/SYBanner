//
//  SYBannerDelegate.swift
//  SYBanner
//
//  Created by Emre Armagan on 06.04.22.
//

import Foundation

@objc
public protocol SYBannerDelegate: AnyObject {
    @objc func notificationBannerWillAppear(_ banner: SYBaseBanner)
    @objc func notificationBannerDidAppear(_ banner: SYBaseBanner)
    @objc func notificationBannerWillDisappear(_ banner: SYBaseBanner)
    @objc func notificationBannerDidDisappear(_ banner: SYBaseBanner)
}
