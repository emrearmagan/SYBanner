//
//  SYBannerDelegate.swift
//  SYBanner
//
//  Created by Emre Armagan on 06.04.22.
//

import Foundation

public protocol SYBannerDelegate: AnyObject {
    func bannerWillAppear(_ banner: SYBaseBanner)
    func bannerDidAppear(_ banner: SYBaseBanner)
    func bannerWillDisappear(_ banner: SYBaseBanner)
    func bannerDidDisappear(_ banner: SYBaseBanner)
}

extension SYBannerDelegate {
    func bannerWillAppear(_ banner: SYBaseBanner) {}
    func bannerDidAppear(_ banner: SYBaseBanner) {}
    func bannerWillDisappear(_ banner: SYBaseBanner) {}
    func bannerDidDisappear(_ banner: SYBaseBanner) {}
}
