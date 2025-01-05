//
//  SYBannerQueueTests.swift
//  SYBanner
//
//  Created by Emre Armagan on 05.01.25.
//  Copyright © 2025 Emre Armagan. All rights reserved.
//

@testable import SYBanner
import UIKit
import XCTest

final class SYBannerQueueTests: XCTestCase {
    private var testingViewController: UIViewController!

    override func setUp() {
        super.setUp()
        testingViewController = UIViewController()
    }

    override func tearDown() {
        testingViewController = nil
        super.tearDown()
    }

    func testAddBanner() {
        let queue = SYBannerQueue(maxBannersOnScreen: 2)
        let banner1 = SYSimpleBanner("Banner 1")
        let banner2 = SYSimpleBanner("Banner 2")

        queue.addBanner(banner1, queuePosition: .back)
        queue.addBanner(banner2, queuePosition: .back)

        XCTAssertEqual(queue.numberOfBanners, 2)
        XCTAssertTrue(queue.banners.contains(banner1))
        XCTAssertTrue(queue.banners.contains(banner2))
    }

    func testRemoveBanner() {
        let queue = SYBannerQueue()
        let banner = SYSimpleBanner("Test Banner")

        queue.addBanner(banner, queuePosition: .back)
        XCTAssertEqual(queue.numberOfBanners, 1)

        queue.removeBanner(banner)
        XCTAssertEqual(queue.numberOfBanners, 0)
    }

    func testMaxBannersOnScreen() {
        let queue = SYBannerQueue(maxBannersOnScreen: 1)
        let banner1 = SYSimpleBanner("Banner 1", on: testingViewController)
        let banner2 = SYSimpleBanner("Banner 2", on: testingViewController)

        queue.addBanner(banner1, queuePosition: .back)
        queue.addBanner(banner2, queuePosition: .back)

        XCTAssertTrue(queue.banners.contains(banner1))
        XCTAssertTrue(queue.banners.contains(banner2))
        XCTAssertEqual(queue.presentedBanners.count, 1)
    }

    func testMaxBannersOnScreenSimultaneously() {
        let queue = SYBannerQueue(maxBannersOnScreen: 2)
        let banner1 = SYSimpleBanner("Banner 1", on: testingViewController)
        let banner2 = SYSimpleBanner("Banner 2", on: testingViewController)
        let banner3 = SYSimpleBanner("Banner 3", on: testingViewController)

        queue.addBanner(banner1, queuePosition: .back)
        queue.addBanner(banner2, queuePosition: .back)
        queue.addBanner(banner3, queuePosition: .back)

        XCTAssertEqual(queue.presentedBanners.count, 2)
        XCTAssertTrue(queue.presentedBanners.contains(banner1))
        XCTAssertTrue(queue.presentedBanners.contains(banner2))
        XCTAssertFalse(queue.presentedBanners.contains(banner3))
    }

    func testDismissAllBanners() {
        let queue = SYBannerQueue(maxBannersOnScreen: 3)
        let banner1 = SYSimpleBanner("Banner 1", on: testingViewController)
        let banner2 = SYSimpleBanner("Banner 2", on: testingViewController)
        let banner3 = SYSimpleBanner("Banner 3", on: testingViewController)

        queue.addBanner(banner1, queuePosition: .back)
        queue.addBanner(banner2, queuePosition: .back)
        queue.addBanner(banner3, queuePosition: .back)

        queue.dismissAll()
        XCTAssertEqual(queue.numberOfBanners, 0)
        XCTAssertEqual(queue.presentedBanners.count, 0)
    }

    func testAddBannerToFront() {
        let queue = SYBannerQueue(maxBannersOnScreen: 1)
        let banner1 = SYSimpleBanner("Banner 1", on: testingViewController)
        let banner2 = SYSimpleBanner("Banner 2", on: testingViewController)

        queue.addBanner(banner1, queuePosition: .back)
        queue.addBanner(banner2, queuePosition: .front)

        XCTAssertEqual(queue.banners.first, banner2)
        XCTAssertEqual(queue.banners.last, banner1)
    }

    func testAddBannerToBack() {
        let queue = SYBannerQueue(maxBannersOnScreen: 1)
        let banner1 = SYSimpleBanner("Banner 1", on: testingViewController)
        let banner2 = SYSimpleBanner("Banner 2", on: testingViewController)

        queue.addBanner(banner1, queuePosition: .back)
        queue.addBanner(banner2, queuePosition: .front)

        XCTAssertEqual(queue.presentedBanners.count, 1)
        XCTAssertTrue(queue.presentedBanners.contains(banner2))
        XCTAssertFalse(queue.presentedBanners.contains(banner1))
    }
    
    func testFirstDisplayedBanner() {
        let queue = SYBannerQueue(maxBannersOnScreen: 1)
        let banner1 = SYSimpleBanner("Banner 1", on: testingViewController)
        let banner2 = SYSimpleBanner("Banner 2", on: testingViewController)

        queue.addBanner(banner1, queuePosition: .back)
        queue.addBanner(banner2, queuePosition: .back)

        XCTAssertEqual(queue.firstDisplayedBanner(), banner1)
    }
    
    func testFirstNotDisplayedBanner() {
        let queue = SYBannerQueue(maxBannersOnScreen: 1)
        let banner1 = SYSimpleBanner("Banner 1", on: testingViewController)
        let banner2 = SYSimpleBanner("Banner 2", on: testingViewController)

        queue.addBanner(banner1, queuePosition: .back)
        queue.addBanner(banner2, queuePosition: .back)

        XCTAssertEqual(queue.firstNotDisplayedBanner(), banner2)
    }
}
