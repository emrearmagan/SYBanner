//
//  NotiflyQueueTests.swift
//  Notifly
//
//  Created by Emre Armagan on 05.01.25.
//  Copyright © 2025 Emre Armagan. All rights reserved.
//

@testable import Notifly
import UIKit
import XCTest

final class NotiflyQueueTests: XCTestCase {
    private var testingViewController: UIViewController!

    override func setUp() {
        super.setUp()
        testingViewController = UIViewController()
    }

    override func tearDown() {
        testingViewController = nil
        super.tearDown()
    }

    func testAddNotification() {
        let queue = NotiflyQueue(maxNotificationsOnScreen: 2)
        let notification1 = Notifly("Notification 1")
        let notification2 = Notifly("Notification 2")

        queue.addNotification(notification1, queuePosition: .back)
        queue.addNotification(notification2, queuePosition: .back)

        XCTAssertEqual(queue.numberOfNotifications, 2)
        XCTAssertTrue(queue.notifications.contains(notification1))
        XCTAssertTrue(queue.notifications.contains(notification2))
    }

    func testRemoveNotification() {
        let queue = NotiflyQueue()
        let notification = Notifly("Test Notification")

        queue.addNotification(notification, queuePosition: .back)
        XCTAssertEqual(queue.numberOfNotifications, 1)

        queue.removeNotification(notification)
        XCTAssertEqual(queue.numberOfNotifications, 0)
    }

    func testMaxNotificationsOnScreen() {
        let queue = NotiflyQueue(maxNotificationsOnScreen: 1)
        let notification1 = Notifly("Notification 1", on: testingViewController)
        let notification2 = Notifly("Notification 2", on: testingViewController)

        queue.addNotification(notification1, queuePosition: .back)
        queue.addNotification(notification2, queuePosition: .back)

        XCTAssertTrue(queue.notifications.contains(notification1))
        XCTAssertTrue(queue.notifications.contains(notification2))
        XCTAssertEqual(queue.presentedNotifications.count, 1)
    }

    func testMaxNotificationsOnScreenSimultaneously() {
        let queue = NotiflyQueue(maxNotificationsOnScreen: 2)
        let notification1 = Notifly("Notification 1", on: testingViewController)
        let notification2 = Notifly("Notification 2", on: testingViewController)
        let notification3 = Notifly("Notification 3", on: testingViewController)

        queue.addNotification(notification1, queuePosition: .back)
        queue.addNotification(notification2, queuePosition: .back)
        queue.addNotification(notification3, queuePosition: .back)

        XCTAssertEqual(queue.presentedNotifications.count, 2)
        XCTAssertTrue(queue.presentedNotifications.contains(notification1))
        XCTAssertTrue(queue.presentedNotifications.contains(notification2))
        XCTAssertFalse(queue.presentedNotifications.contains(notification3))
    }

    func testDismissAllNotifications() {
        let queue = NotiflyQueue(maxNotificationsOnScreen: 3)
        let notification1 = Notifly("Notification 1", on: testingViewController)
        let notification2 = Notifly("Notification 2", on: testingViewController)
        let notification3 = Notifly("Notification 3", on: testingViewController)

        queue.addNotification(notification1, queuePosition: .back)
        queue.addNotification(notification2, queuePosition: .back)
        queue.addNotification(notification3, queuePosition: .back)

        queue.dismissAll()
        XCTAssertEqual(queue.numberOfNotifications, 0)
        XCTAssertEqual(queue.presentedNotifications.count, 0)
    }

    func testAddNotificationToFront() {
        let queue = NotiflyQueue(maxNotificationsOnScreen: 1)
        let notification1 = Notifly("Notification 1", on: testingViewController)
        let notification2 = Notifly("Notification 2", on: testingViewController)

        queue.addNotification(notification1, queuePosition: .back)
        queue.addNotification(notification2, queuePosition: .front)

        XCTAssertEqual(queue.notifications.first, notification2)
        XCTAssertEqual(queue.notifications.last, notification1)
    }

    func testAddNotificationToBack() {
        let queue = NotiflyQueue(maxNotificationsOnScreen: 1)
        let notification1 = Notifly("Notification 1", on: testingViewController)
        let notification2 = Notifly("Notification 2", on: testingViewController)

        queue.addNotification(notification1, queuePosition: .back)
        queue.addNotification(notification2, queuePosition: .front)

        XCTAssertEqual(queue.presentedNotifications.count, 1)
        XCTAssertTrue(queue.presentedNotifications.contains(notification2))
        XCTAssertFalse(queue.presentedNotifications.contains(notification1))
    }

    func testFirstDisplayedNotification() {
        let queue = NotiflyQueue(maxNotificationsOnScreen: 1)
        let notification1 = Notifly("Notification 1", on: testingViewController)
        let notification2 = Notifly("Notification 2", on: testingViewController)

        queue.addNotification(notification1, queuePosition: .back)
        queue.addNotification(notification2, queuePosition: .back)

        XCTAssertEqual(queue.firstDisplayedNotification(), notification1)
    }

    func testFirstNotDisplayedNotification() {
        let queue = NotiflyQueue(maxNotificationsOnScreen: 1)
        let notification1 = Notifly("Notification 1", on: testingViewController)
        let notification2 = Notifly("Notification 2", on: testingViewController)

        queue.addNotification(notification1, queuePosition: .back)
        queue.addNotification(notification2, queuePosition: .back)

        XCTAssertEqual(queue.firstNotDisplayedNotification(), notification2)
    }
}
