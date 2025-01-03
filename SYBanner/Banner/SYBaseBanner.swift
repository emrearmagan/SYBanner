//
//  SYBaseBanner.swift
//  SYBanner
//
//  Created by Emre Armagan on 06.04.22.
//

import Foundation
import UIKit

/// The base class for all banners, providing functionality for presentation, dismissal, and interaction.
open class SYBaseBanner: UIView {
    // MARK: Properties

    /// The haptic feedback to be triggered when the banner is presented. See `SYBannerFeedback` for more
    /// - Default: `.impact(style: .light)`
    public var feedback: SYBannerFeedback = .impact(style: .light)

    /// Closure executed when the banner is tapped. Default dimissed the Banner
    public var didTap: (() -> Void)?

    /// Closure executed when the banner is swiped. Default dimissed the Banner
    public var onSwipe: ((UISwipeGestureRecognizer) -> Void)?

    /// The direction from which the banner will appear (e.g., `.top` or `.bottom`).
    public var direction: SYBannerDirection

    /// Delegate to handle banner lifecycle events.
    public weak var delegate: SYBannerDelegate?

    /// The current state of the banner during its lifecycle.
    public var state: SYBannerState {
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
    open var prefferedContainerSize: CGSize {
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

        didTap = { [weak self] in
            guard let self = self else { return }
            self.dismiss()
        }

        onSwipe = { [weak self] _ in
            guard let self = self else { return }
            self.dismiss()
        }
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
        delegate?.bannerWillAppear(self)
        feedback.generate()

        presenter.present(banner: self, in: superview) { [weak self] in
            guard let self = self else { return }

            self.delegate?.bannerDidAppear(self)
            self.addGestureRecognizers()
            self.hasBeenSeen = true
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

        delegate?.bannerWillDisappear(self)
        bannerQueue.removeBanner(self, showNextInQueue: showNext)

        presenter.dismiss(banner: self) { [weak self] in
            defer { completion?() }
            guard let self = self else { return }
            self.delegate?.bannerDidDisappear(self)
        }
    }

    /// Returns the preferred content size for the banner. Default is the auto layout size.
    open func preferredContentSize() -> CGSize {
        let autoLayoutSize = systemLayoutSizeFitting(prefferedContainerSize)
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
    /// banner.text = "Hello Banner!"
    /// banner.setNeedsBannerDisplay()
    /// ```
    open func setNeedsBannerDisplay() {
        guard state == .presented || state == .presenting else { return }
        bannerQueue.layoutPresentedBannersIfNeeded()
    }

    /// Invalidates the banner's content size and updates its frame size.
    private func invalidateContentSize() {
        frame.size = preferredContentSize()
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
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTapGestureRecognizer(sender:)))
        tapGestureRecognizer.delaysTouchesBegan = false
        tapGestureRecognizer.delaysTouchesEnded = false
        addGestureRecognizer(tapGestureRecognizer)

        let swipeUpGesture = UISwipeGestureRecognizer(target: self, action: #selector(onSwipeGestureRecognizer(sender:)))
        addGestureRecognizer(swipeUpGesture)
    }

    /// Handles tap gestures on the banner.
    @objc open func onTapGestureRecognizer(sender: UITapGestureRecognizer) {
        guard state == .presented else { return }
        didTap?()
    }

    /// Handles swipe gestures on the banner.
    @objc open func onSwipeGestureRecognizer(sender: UISwipeGestureRecognizer) {
        guard state == .presented else { return }
        onSwipe?(sender)
    }
}
