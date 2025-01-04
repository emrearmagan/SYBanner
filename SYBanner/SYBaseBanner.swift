//
//  SYBaseBanner.swift
//  SYBanner
//
//  Created by Emre Armagan on 06.04.22.
//

import Foundation
import UIKit

/// The base class for all banners, providing functionality for presentation, dismissal, and interaction.
open class SYBaseBanner: UIControl {
    // MARK: Properties

    let customLayoutGuide = UILayoutGuide()

    /// The haptic feedback to be triggered when the banner is presented. See `SYBannerFeedback` for more
    /// - Default: `.impact(style: .light)`
    public var feedback: SYBannerFeedback = .impact(style: .light)

    /// The highlighter responsible for handling touch interactions such as highlighting and unhighlighting the banner.
    /// - Default: `SYDefaultHighlighter`
    public var highlighter: SYBannerHighlighter? = SYDefaultHighlighter()

    /// Indicates whether the banner should automatically dismiss itself after a specified interval.
    /// - Default: `true`
    public var autoDismiss: Bool = false

    /// The time interval after which the banner will automatically dismiss itself, if `autoDismiss` is enabled.
    /// - Default: `2 seconds`
    public var autoDismissInterval: TimeInterval = 2
    /// Closure executed when the banner is tapped. Default dimissed the Banner
    public var didTap: (() -> Void)?

    /// Closure executed when the banner is swiped. Default dimissed the Banner
    public var onSwipe: ((UISwipeGestureRecognizer) -> Void)?

    /// The direction from which the banner will appear (e.g., `.top` or `.bottom`).
    public var direction: SYBannerDirection

    /// Delegate to handle banner lifecycle events.
    public weak var delegate: SYBannerDelegate?

    /// The current state of the banner during its lifecycle.
    public var presentationState: SYBannerState {
        presenter.state
    }

    /// The type of the banner (e.g., stick or float).
    public var bannerType: SYBannerType = .float(.vertical(5) + .horizontal(10))

    /// The insets applied to the banner based on its type.
    public var bannerInsets: UIEdgeInsets {
        switch bannerType {
            case .stick:
                return .all(0)

            case let .float(insets):
                var bannerInsets = insets
                bannerInsets += .bottom(parentSafeArea.bottom) + .top(parentSafeArea.top) + .left(parentSafeArea.left) + .right(parentSafeArea.right)
                return bannerInsets

            case let .ignoringSafeArea(inset):
                return inset
        }
    }

    /// The parent view controller in which the banner is displayed.
    open weak var parentViewController: UIViewController?

    /// Indicates whether the banner has been shown at least once.
    public private(set) var hasBeenSeen = false

    /// The preferred container size for the banner.
    open var preferredContainerSize: CGSize {
        return CGSize(
            width: screenSize.width - bannerInsets.left - bannerInsets.right,
            height: screenSize.height - bannerInsets.top - bannerInsets.top
        )
    }

    /// The queue where the banner will be placed.
    public private(set) var bannerQueue: SYBannerQueue

    /// The presenter responsible for animating the banner.
    let presenter: SYBannerPresenter

    /// The screen size of the device.
    private let screenSize: CGSize = UIScreen.main.bounds.size

    /// A work item representing the scheduled auto-dismiss task.
    private var autoDismissTask: DispatchWorkItem?

    /// The main application window used for placing the banner.
    private weak var appWindow: UIView? = (UIApplication.shared.connectedScenes
        .filter { $0.activationState == .foregroundActive }
        .compactMap { $0 as? UIWindowScene }
        .first?.windows
        .filter { $0.isKeyWindow }.first?.rootViewController?.view) ?? nil

    // MARK: - Init

    /// Initializes a new instance of `SYBaseBanner`.
    ///
    /// - Parameters:
    ///   - direction: The direction from which the banner will appear.
    ///   - presentation: The presenter responsible for animating the banner. Defaults to `SYFadePresenter`.
    ///   - queue: The queue managing the banner. Defaults to `.default`.
    ///   - parent: The parent view controller where the banner will be displayed.
    public init(direction: SYBannerDirection,
                presentation: SYBannerPresenter = SYDefaultPresenter(),
                queue: SYBannerQueue = .default,
                on parent: UIViewController? = nil) {
        self.direction = direction
        presenter = presentation
        parentViewController = parent
        bannerQueue = queue

        super.init(frame: .zero)
        insetsLayoutMarginsFromSafeArea = false
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Functions

    /// Presents the banner, optionally adding it to a queue.
    ///
    /// - Parameters:
    ///   - placeOnQueue: Whether the banner should be added to the queue. Defaults to `true`.
    ///   - queuePosition: The position in the queue where the banner should be added. Defaults to `.back`.
    ///   - completion: A closure executed after the banner is presented.
    public final func present(
        placeOnQueue: Bool = true,
        queuePosition: SYBannerQueue.QueuePosition = .back,
        _ completion: (() -> Void)? = nil
    ) {
        if placeOnQueue {
            bannerQueue.addBanner(self, queuePosition: queuePosition)
        } else {
            presentBanner(completion: completion)
        }
    }

    /// Dismisses the banner and removes it from its parent view.
    ///
    /// - Parameters:
    ///   - showNext: Whether to show the next banner in the queue. Defaults to `true`.
    ///   - completion: A closure executed after the banner is dismissed.
    public final func dismiss(showNext: Bool = true, completion: (() -> Void)? = nil) {
        dismissBanner(showNext: showNext, completion)
    }

    /// Presents the banner without adding it to a queue. Used internally by the queue.
    private func presentBanner(completion: (() -> Void)?) {
        if !Thread.isMainThread {
            DispatchQueue.main.async { [weak self] in
                self?.presentBanner(completion: completion)
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

        delegate?.bannerWillAppear(self)
        feedback.generate()
        presenter.present(banner: self, in: superview) { [weak self] in
            guard let self = self else { return }
            self.addGestureRecognizers()
            self.hasBeenSeen = true
            self.scheduleAutoDismiss()
            self.delegate?.bannerDidAppear(self)
            completion?()
        }
    }

    /// Dismisses the banner without removing it from the queue. Used internally by the queue.
    private func dismissBanner(showNext: Bool, _ completion: (() -> Void)?) {
        if !Thread.isMainThread {
            DispatchQueue.main.async { [weak self] in
                self?.dismissBanner(showNext: showNext, completion)
            }
            return
        }

        autoDismissTask?.cancel()
        autoDismissTask = nil

        delegate?.bannerWillDisappear(self)
        bannerQueue.removeBanner(self, showNextInQueue: showNext)

        if let superview = superview {
            presenter.dismiss(banner: self, in: superview) { [weak self] in
                defer { completion?() }
                guard let self = self else { return }
                self.removeFromSuperview()
                self.delegate?.bannerDidDisappear(self)
            }
            return
        }

        delegate?.bannerDidDisappear(self)
    }

    /// Returns the preferred content size for the banner. Default is the auto layout size.
    open func preferredContentSize() -> CGSize {
        let autoLayoutSize = systemLayoutSizeFitting(preferredContainerSize,
                                                     withHorizontalFittingPriority: .required,
                                                     verticalFittingPriority: .fittingSizeLevel)
        return autoLayoutSize
    }

    /// Requests the banner to re-evaluate its layout and adjust its position.
    ///
    /// This method ensures that any banners currently presented or in the process of being presented
    /// (`.presented` or `.presenting` states) are re-aligned within the queue. It triggers the banner queue
    /// to layout all presented banners if necessary, maintaining correct stacking and alignment.
    ///
    /// Use this method when the banner's content, size, or layout changes, and you need to update its
    /// position relative to other banners in the queue.
    ///
    /// Example:
    /// ```swift
    /// banner.present()
    /// banner.text = "Hello Banner!"
    /// banner.setNeedsBannersDisplay()
    /// ```
    open func setNeedsBannersDisplay() {
        guard presentationState == .presented || presentationState == .presenting else { return }
        invalidateContentSize()
        bannerQueue.layoutPresentedBannersIfNeeded()
    }

    /// Invalidates the banner's content size and updates its frame size.
    private func invalidateContentSize() {
        frame.size = preferredContentSize()
    }

    /// Schedules the automatic dismissal of the banner after the specified interval.
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

extension SYBaseBanner {
    /// The parent view where the banner will be displayed.
    public var parentView: UIView? {
        parentViewController?.view ?? appWindow
    }

    /// The safe area insets of the parent view.
    public var parentSafeArea: UIEdgeInsets {
        parentView?.safeAreaInsets ?? .zero
    }
}

// MARK: - Gesture Handling

extension SYBaseBanner {
    /// Adds gesture recognizers for interaction with the banner.
    private func addGestureRecognizers() {
        let swipeUpGesture = UISwipeGestureRecognizer(target: self, action: #selector(onSwipeGestureRecognizer(sender:)))
        addGestureRecognizer(swipeUpGesture)
    }

    /// Handles swipe gestures on the banner.
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

extension SYBaseBanner {
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
