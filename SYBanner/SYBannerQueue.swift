//
//  SYBannerQueue.swift
//  SYBanner
//
//  Created by Emre Armagan on 06.04.22.
//
import Foundation

@objc(SYBannerQueuePosition)
public enum QueuePosition: Int {
    case back
    case front
}

open class SYBannerQueue: NSObject {
    // MARK: Properties

    @objc(defaultQueue)
    public static let `default` = SYBannerQueue()

    /// The banners currently placed in the queue
    @objc
    private(set) var banners: [SYBaseBanner] = []

    /// Number of banners that can be visible at the same time
    @objc
    private(set) var maxBannersOnScreenSimultaneously: Int = 1

    /// The number of notification banners in the queue
    @objc
    public var numberOfBanners: Int {
        return banners.count
    }

    // MARK: Init

    @objc
    public init(maxBannersOnScreen: Int = 1) {
        maxBannersOnScreenSimultaneously = maxBannersOnScreen
    }

    // MARK: Functions

    /// Adds a banner to the queue
    @objc
    func addBanner(_ banner: SYBaseBanner, queuePosition: QueuePosition) {
        let currentBannersCount = banners.filter { $0.isDisplaying }.count

        if queuePosition == .back {
            banners.append(banner)

            if currentBannersCount < maxBannersOnScreenSimultaneously {
                banner.show(placeOnQueue: false)
            }
        } else {
            if let fistDisplayed = getFirstDisplayedBanner() {
                fistDisplayed.dismissView()
            }

            banners.insert(banner, at: 0)
            if currentBannersCount < maxBannersOnScreenSimultaneously {
                banner.show(placeOnQueue: false)
            }
        }
    }

    @objc
    func getFirstDisplayedBanner() -> SYBaseBanner? {
        return banners.filter { $0.isDisplaying }.first
    }

    /// Removes a banner from the queue
    /// -parameter banner: A notification banner to remove from the queue.
    @objc
    func removeBanner(_ banner: SYBaseBanner) {
        if let index = banners.firstIndex(of: banner) {
            banners.remove(at: index)
        }
        showNext()
    }

    /// Shows the next notificaiton banner on the queue if one exists
    @objc
    func showNext() {
        if let banner = firstNotDisplayedBanner() {
            banner.show(placeOnQueue: false)
        }
    }

    /// Returns the first banner that is currently not displaying
    @objc
    func firstNotDisplayedBanner() -> SYBaseBanner? {
        return banners.filter { !$0.isDisplaying }.first
    }

    /// Removes all banners from the queuea
    @objc
    public func removeAll() {
        banners.removeAll()
    }
}
