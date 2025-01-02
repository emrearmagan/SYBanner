//
//  SYBaseBanner.swift
//  SYBanner
//
//  Created by Emre Armagan on 06.04.22.
//

import UIKit

public enum Direction: Int {
    case bottom
    case top
    case left
    case right
}

public enum SYBannerType: Int {
    case custom
    case float
    case stick
}

open class SYBaseBanner: UIView {
    // MARK: Properties

    /// screen size of the phone
    let screenSize: CGSize = UIScreen.main.bounds.size

    lazy var safeArea: UIEdgeInsets? = parentView?.safeAreaInsets

    /// Insets of the banner on each size
    public var bannerInsets: UIEdgeInsets = .init(top: 0, left: 10, bottom: 0, right: 10)

    /// The direction the notification should appear from
    public private(set) var direction: Direction
    /// Indicates wheter the notification is currently displaying
    public private(set) var isDisplaying = false
    /// Indicates wheter the notification has been already shown
    public private(set) var hasBeenSeen = false

    /// The main window of the application which banner views are placed on
    private weak var appWindow: UIView? = (UIApplication.shared.connectedScenes
        .filter { $0.activationState == .foregroundActive }
        .compactMap { $0 as? UIWindowScene }
        .first?.windows
        .filter { $0.isKeyWindow }.first?.rootViewController?.view) ?? nil

    /// Indicates that the notification is currently dismissing
    private var isDismissing: Bool = false

    var bannerType: SYBannerType = .float {
        didSet {
            switch bannerType {
                case .float:
                    bannerInsets = .init(top: (safeArea?.top ?? 0), left: 10, bottom: (safeArea?.bottom ?? 0), right: 10)
                case .stick:
                    bannerInsets = .init(top: 0, left: 0, bottom: 0, right: 0)
                case .custom:
                    break
            }
        }
    }

    /// The view controller to display the banner on. This is useful if you are wanting to display a banner only on one ViewController and not on the whole screen
    weak var parentViewController: UIViewController?

    /// The delegate of the notification banner
    public weak var delegate: SYBannerDelegate?

    /// animation duration of the notification for appearing
    public var animationDurationShow: CGFloat = 0.5

    /// animation duration of the notification for disappearing
    public var animationDurationDisappear: CGFloat = 0.5

    /// duration for whole long the notification should appear on the screen
    public var appearanceDuration: TimeInterval = 5

    /// Responsible for positioning and auto managing notification banners
    public var bannerQueue: SYBannerQueue = .default

    /// If false, the banner will not be dismissed until the developer programatically dismisses it
    public var autoDismiss: Bool = true {
        didSet {
            if !autoDismiss {
                dismissOnTap = false
                dismissOnSwipe = false
            }
        }
    }

    /// If true, notification will dismissed when tapped
    public var dismissOnTap: Bool = true

    /// If true, notification will dismissed when swiped up
    public var dismissOnSwipe: Bool = true

    /// Closure that will be executed if the notification banner is swiped up
    public var onSwipe: (() -> Void)?

    /// Closure that will be executed if the notification banner is tapped
    public var didTap: (() -> Void)?

    /// The transparency of the background of the notification banner
    public var transparency: CGFloat = 1 {
        didSet {
            backgroundColor = backgroundColor?.withAlphaComponent(transparency)
        }
    }

    /// The type of haptic to generate when a banner is displayed
    public var haptic: UIImpactFeedbackGenerator.FeedbackStyle = .medium

    // MARK: init

    init(direction: Direction, on: UIViewController?, type: SYBannerType = .float) {
        // Defer to call the didSet method on bannerType
        defer {
            self.bannerType = type
        }
        self.direction = direction
        parentViewController = on
        super.init(frame: .zero)
    }

    @available(*, unavailable)
    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Functions

    func postionView() {
        fatalError("postionView(): has not been implemented for BaseNotificationBanner")
    }

    func positionFinalFrame(_ animate: Bool = true, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: animate ? animationDurationShow : 0, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [.curveLinear, .allowUserInteraction]) {
            switch self.direction {
                case .bottom:
                    self.frame.origin.y = self.screenSize.height - self.bannerInsets.bottom - self.frame.size.height
                case .top:
                    self.frame.origin.y = self.bannerInsets.top
                case .left:
                    self.frame.origin.x = self.bannerInsets.left
                case .right:
                    self.frame.origin.x = self.screenSize.width - self.bannerInsets.left - self.frame.size.width
            }
        } completion: { _ in
            completion?()
        }
    }

    /// Places a NotificationBanner on the queue and shows it if its the first one in the queue
    public func show(queuePosition: SYBannerQueue.QueuePosition = .back) {
        show(placeOnQueue: true, queuePosition: queuePosition)
    }

    /// Places a NotificationBanner on the queue if option is selected otherwise shows it immediately
    public func show(placeOnQueue: Bool, queuePosition: SYBannerQueue.QueuePosition = .back) {
        postionView()
        guard !isDisplaying else { return }
        if placeOnQueue {
            bannerQueue.addBanner(self, queuePosition: queuePosition)
        } else {
            animateView()
            if autoDismiss {
                DispatchQueue.main.asyncAfter(deadline: .now() + appearanceDuration) {
                    self.dismissView()
                }
            }
        }
    }

    /// Removes the NotificationBanner from the queue if not displaying
    public func remove() {
        guard !isDisplaying else { return }
        bannerQueue.removeBanner(self)
    }

    /// Add a TapGesture to the View
    private func addTapGesture() {
        if dismissOnTap {
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTapGestureRecognizer(sender:)))
            addGestureRecognizer(tapGestureRecognizer)
        }
    }

    /// Add a SwipeGesture to the View depending on the direction
    func addSwipegesture() {
        if dismissOnSwipe {
            let swipeUpGesture = UISwipeGestureRecognizer(target: self, action: #selector(onSwipeGestureRecognizer))
            swipeUpGesture.direction = (direction == .bottom) ? .down : .up
            addGestureRecognizer(swipeUpGesture)
        }
    }

    /// Called when a notification banner is swiped up
    @objc func onSwipeGestureRecognizer() {
        guard isDisplaying else { return }
        didTap?()
        dismissView()

        onSwipe?()
    }

    /// Called when a notification banner is tapped
    @objc private func onTapGestureRecognizer(sender _: UITapGestureRecognizer) {
        guard isDisplaying else { return }
        didTap?()
        dismissView()
    }
}

public extension SYBaseBanner {
    /// the parent view to display the banner

    dynamic var parentView: UIView? {
        if let vc = parentViewController {
            return vc.view
        }
        return appWindow
    }

    /// animates the notification banner from the defined direction in
    @objc internal func animateView() {
        guard let superView = parentView else { return }
        isDisplaying = true

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            superView.addSubview(self)
            self.delegate?.bannerWillAppear(self)

            UIImpactFeedbackGenerator(style: self.haptic).impactOccurred()

            self.positionFinalFrame {
                self.addTapGesture()
                self.addSwipegesture()
                self.delegate?.bannerDidAppear(self)
                self.hasBeenSeen = true
            }
        }
    }

    /// dismisses  the notification banner from the opposite of defined direction
    @objc func dismissView(_ completion: (() -> Void)? = nil) {
        guard !isDismissing else { return }
        isDismissing = true
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.delegate?.bannerWillDisappear(self)

            UIView.animate(withDuration: self.animationDurationDisappear, delay: 0, options: [.curveLinear, .allowUserInteraction]) {
                guard self.isDisplaying else { return }
                switch self.direction {
                    case .bottom:
                        self.frame.origin.y = self.screenSize.height + self.frame.size.height
                    case .top:
                        self.frame.origin.y = -self.frame.size.height
                    case .left:
                        self.frame.origin.x = -self.frame.size.width
                    case .right:
                        self.frame.origin.x = self.frame.size.width + self.screenSize.width
                }

            } completion: { _ in
                self.bannerQueue.removeBanner(self)
                self.isDisplaying = false
                self.isDismissing = false
                self.delegate?.bannerDidDisappear(self)
                self.removeFromSuperview()
                completion?()
            }
        }
    }
}
