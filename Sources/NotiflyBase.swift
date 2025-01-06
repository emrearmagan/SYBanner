//
//  NotiflyBase.swift
//  Notifly
//
//  Created by Emre Armagan on 06.04.22.
//

import Foundation
import UIKit

/// The base class for all notifications, providing functionality for presentation, dismissal, and interaction.
open class NotiflyBase: UIControl {
    // MARK: Properties

    /// The haptic feedback to be triggered when the notification is presented. See `SYNotificationFeedback` for more
    /// - Default: `.impact(style: .light)`
    public var feedback: NotiflyFeedback = .impact(style: .light)

    /// The highlighter responsible for handling touch interactions such as highlighting and unhighlighting the notification.
    /// - Default: `SYDefaultHighlighter`
    public var highlighter: NotiflyHighlighter? = NotiflyDefaultHighlighter()

    /// Indicates whether the notification should automatically dismiss itself after a specified interval.
    /// - Default: `true`
    public var autoDismiss: Bool = false

    /// The time interval after which the notification will automatically dismiss itself, if `autoDismiss` is enabled.
    /// - Default: `2 seconds`
    public var autoDismissInterval: TimeInterval = 2

    /// Closure executed when the notification is tapped. Default dismisses the notification.
    public var didTap: (() -> Void)?

    /// Closure executed when the notification is swiped. Default dismisses the notification.
    public var onSwipe: ((UISwipeGestureRecognizer) -> Void)?

    /// The direction from which the notification will appear (e.g., `.top` or `.bottom`).
    public var direction: NotiflyDirection

    /// Delegate to handle notification lifecycle events.
    public weak var delegate: NotiflyDelegate?

    /// The current state of the notification during its lifecycle.
    public var presentationState: NotiflyState {
        presenter.state
    }

    /// The type of the notification (e.g., stick or float).
    public var type: NotiflyType = .float(.vertical(5) + .horizontal(10))

    /// The insets applied to the notification based on its type.
    public var notificationInsets: UIEdgeInsets {
        switch type {
            case .stick:
                return .all(0)

            case let .float(insets):
                var notificationInsets = insets
                notificationInsets += .bottom(parentSafeArea.bottom) + .top(parentSafeArea.top) + .left(parentSafeArea.left) + .right(parentSafeArea.right)
                return notificationInsets

            case let .ignoringSafeArea(inset):
                return inset
        }
    }

    /// The parent view controller in which the notification is displayed.
    open weak var parentViewController: UIViewController?

    /// Indicates whether the notification has been shown at least once.
    public private(set) var hasBeenSeen = false

    /// The preferred container size for the notification.
    open var preferredContainerSize: CGSize {
        return CGSize(
            width: screenSize.width - notificationInsets.left - notificationInsets.right,
            height: screenSize.height - notificationInsets.top - notificationInsets.top
        )
    }

    /// The queue where the notification will be placed.
    public private(set) var notificationQueue: NotiflyQueue

    /// The presenter responsible for animating the notification.
    let presenter: NotiflyPresenter

    /// The screen size of the device.
    private let screenSize: CGSize = UIScreen.main.bounds.size

    /// A work item representing the scheduled auto-dismiss task.
    private var autoDismissTask: DispatchWorkItem?

    /// The main application window used for placing the notification.
    private weak var appWindow: UIView? = (UIApplication.shared.connectedScenes
        .filter { $0.activationState == .foregroundActive }
        .compactMap { $0 as? UIWindowScene }
        .first?.windows
        .filter { $0.isKeyWindow }.first?.rootViewController?.view) ?? nil

    // MARK: - Init

    /// Initializes a new instance of `NotiflyBase`.
    ///
    /// - Parameters:
    ///   - direction: The direction from which the notification will appear.
    ///   - presentation: The presenter responsible for animating the notification. Defaults to `SYFadePresenter`.
    ///   - queue: The queue managing the notification. Defaults to `.default`.
    ///   - parent: The parent view controller where the notification will be displayed.
    public init(direction: NotiflyDirection,
                presentation: NotiflyPresenter = NotiflyDefaultPresenter(),
                queue: NotiflyQueue = .default,
                on parent: UIViewController? = nil) {
        self.direction = direction
        presenter = presentation
        parentViewController = parent
        notificationQueue = queue

        super.init(frame: .zero)
        insetsLayoutMarginsFromSafeArea = false
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Functions

    /// Presents the notification, optionally adding it to a queue.
    ///
    /// - Parameters:
    ///   - placeOnQueue: Whether the notification should be added to the queue. Defaults to `true`.
    ///   - queuePosition: The position in the queue where the notification should be added. Defaults to `.back`.
    ///   - completion: A closure executed after the notification is presented.
    public final func present(
        placeOnQueue: Bool = true,
        queuePosition: NotiflyQueue.QueuePosition = .back,
        _ completion: (() -> Void)? = nil
    ) {
        if placeOnQueue {
            notificationQueue.addNotification(self, queuePosition: queuePosition)
        } else {
            presentNotification(completion: completion)
        }
    }

    /// Dismisses the notification and removes it from its parent view.
    ///
    /// - Parameters:
    ///   - showNext: Whether to show the next notification in the queue. Defaults to `true`.
    ///   - completion: A closure executed after the notification is dismissed.
    public final func dismiss(showNext: Bool = true, completion: (() -> Void)? = nil) {
        dismissNotification(showNext: showNext, completion)
    }

    /// Presents the notification without adding it to a queue. Used internally by the queue.
    private func presentNotification(completion: (() -> Void)?) {
        if !Thread.isMainThread {
            DispatchQueue.main.async { [weak self] in
                self?.presentNotification(completion: completion)
            }
            return
        }

        guard let superview = parentView else { return }
        invalidateContentSize()

        if !isDescendant(of: superview) {
            removeFromSuperview() // we still remove it first in case the superView was previously some other window
            superview.addSubview(self)
            superview.bringSubviewToFront(self)
        }

        delegate?.notificationWillAppear(self)
        feedback.generate()
        presenter.present(notification: self, in: superview) { [weak self] in
            guard let self = self else { return }
            self.addGestureRecognizers()
            self.hasBeenSeen = true
            self.scheduleAutoDismiss()
            self.delegate?.notificationDidAppear(self)
            completion?()
        }
    }

    /// Dismisses the notification without removing it from the queue. Used internally by the queue.
    private func dismissNotification(showNext: Bool, _ completion: (() -> Void)?) {
        if !Thread.isMainThread {
            DispatchQueue.main.async { [weak self] in
                self?.dismissNotification(showNext: showNext, completion)
            }
            return
        }

        autoDismissTask?.cancel()
        autoDismissTask = nil

        delegate?.notificationWillDisappear(self)
        notificationQueue.removeNotification(self, showNextInQueue: showNext)

        if let superview = superview {
            presenter.dismiss(notification: self, in: superview) { [weak self] in
                defer { completion?() }
                guard let self = self else { return }
                self.removeFromSuperview()
                self.delegate?.notificationDidDisappear(self)
            }
            return
        }

        delegate?.notificationDidDisappear(self)
    }

    /// Returns the preferred content size for the notifications. Default is the auto layout size.
    open func preferredContentSize() -> CGSize {
        let autoLayoutSize = systemLayoutSizeFitting(preferredContainerSize,
                                                     withHorizontalFittingPriority: .required,
                                                     verticalFittingPriority: .fittingSizeLevel)
        return autoLayoutSize
    }

    /// Requests the notification to re-evaluate its layout and adjust its position.
    ///
    /// This method ensures that any notifications currently presented or in the process of being presented
    /// (`.presented` or `.presenting` states) are re-aligned within the queue. It triggers the notification queue
    /// to layout all presented notifications if necessary, maintaining correct stacking and alignment.
    ///
    /// Use this method when the notification's content, size, or layout changes, and you need to update its
    /// position relative to other notifications in the queue.
    ///
    /// Example:
    /// ```swift
    /// notification.present()
    /// notification.text = "Hello Notification!"
    /// notification.setNeedsNotificationsDisplay()
    /// ```
    open func setNeedsNotificationsDisplay() {
        guard presentationState == .presented || presentationState == .presenting else { return }
        invalidateContentSize()
        notificationQueue.layoutPresentedNotificationsIfNeeded()
    }

    /// Invalidates the notification's content size and updates its frame size.
    private func invalidateContentSize() {
        frame.size = preferredContentSize()
    }

    /// Schedules the automatic dismissal of the notification after the specified interval.
    private func scheduleAutoDismiss() {
        autoDismissTask?.cancel()
        guard autoDismiss else { return }

        let task = DispatchWorkItem { [weak self] in
            guard let self = self, self.presentationState == .presented else { return }
            self.dismiss()
        }

        autoDismissTask = task
        DispatchQueue.main.asyncAfter(deadline: .now() + autoDismissInterval, execute: task)
    }
}

// MARK: - Helper

extension NotiflyBase {
    /// The parent view where the notification will be displayed.
    public var parentView: UIView? {
        parentViewController?.view ?? appWindow
    }

    /// The safe area insets of the parent view.
    public var parentSafeArea: UIEdgeInsets {
        parentView?.safeAreaInsets ?? .zero
    }
}

// MARK: - Gesture Handling

extension NotiflyBase {
    private func addGestureRecognizers() {
        let swipeUpGesture = UISwipeGestureRecognizer(target: self, action: #selector(onSwipeGestureRecognizer(sender:)))
        addGestureRecognizer(swipeUpGesture)
    }

    @objc open func onSwipeGestureRecognizer(sender: UISwipeGestureRecognizer) {
        guard presentationState == .presented else { return }
        if let onSwipe {
            onSwipe(sender)
            return
        }

        dismiss()
    }
}

// MARK: - Touch

extension NotiflyBase {
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard presentationState == .presented else {
            highlighter?.stopHighlight(self)
            return
        }

        if let touch = touches.first {
            let location = touch.location(in: self)
            highlighter?.locationMoved(self, to: location)
        }
    }

    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard presentationState == .presented else { return }

        if let touch = touches.first {
            let location = touch.location(in: self)
            highlighter?.highlight(self, at: location)
        }
    }

    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        highlighter?.stopHighlight(self)

        guard presentationState == .presented,
              let touch = touches.first,
              bounds.contains(touch.location(in: self)) else { return }

        if let onDismiss = didTap {
            onDismiss()
            return
        }

        dismiss()
    }

    override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        highlighter?.stopHighlight(self)
    }
}
