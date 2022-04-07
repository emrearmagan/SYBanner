//
//  SYBaseBanner.swift
//  SYBanner
//
//  Created by Emre Armagan on 06.04.22.
//

import UIKit

public enum Direction {
    case bottom
    case top
}

public enum SYBannerType {
    case custom
    case float
    case stick
}

open class SYBaseBanner: UIView {
    //MARK: Properties
    
    /// screen size of the phone
    internal let screenSize: CGSize = {
        return UIScreen.main.bounds.size
    }()
    
    internal lazy var safeArea: UIEdgeInsets? = {
        return parentView?.safeAreaInsets
    }()
    
    /// Insets of the banner on each size
    public var bannerInsets: UIEdgeInsets = .init(top: 0, left: 10, bottom: 0, right: 10)
    
    /// The direction the notification should appear from
    public private(set) var direction: Direction
    /// Indicates wheter the notification is currently displaying
    public private(set) var isDisplaying = false
    /// Indicates wheter the notification has been already shown
    public private(set) var hasBeenSeen = false
    
    /// The main window of the application which banner views are placed on
    private weak var appWindow: UIView? = {
        return (UIApplication.shared.connectedScenes
                    .filter({$0.activationState == .foregroundActive})
                    .compactMap({$0 as? UIWindowScene})
                    .first?.windows
                    .filter({$0.isKeyWindow}).first?.rootViewController?.view) ?? nil
    }()
    
    /// Indicates that the notification is currently dismissing
    private var isDismissing: Bool = false
    
    internal var bannerType: SYBannerType = .float {
        didSet {
            switch bannerType {
            case .float:
                self.bannerInsets = .init(top: (self.safeArea?.top ?? 0), left: 10, bottom: (self.safeArea?.bottom ?? 0), right: 10)
            case .stick:
                self.bannerInsets = .init(top: 0, left: 0, bottom: 0, right: 0)
            case .custom:
                break
            }
        }
    }
    
    /// The view controller to display the banner on. This is useful if you are wanting to display a banner only on one ViewController and not on the whole screen
    public weak var parentViewController: UIViewController?
    
    /// The delegate of the notification banner
    public weak var delegate: SYBannerDelegate?
    
    /// animation duration of the notification for appearing
    public var animationDurationShow: CGFloat       = 0.5
    
    /// animation duration of the notification for disappearing
    public var animationDurationDisappear: CGFloat       = 0.5
    
    /// duration for whole long the notification should appear on the screen
    public var appearanceDuration: TimeInterval = 5
    
    /// Responsible for positioning and auto managing notification banners
    public var bannerQueue: SYBannerQueue = SYBannerQueue.default

    
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
            self.backgroundColor = self.backgroundColor?.withAlphaComponent(transparency)
        }
    }
    
    /// The type of haptic to generate when a banner is displayed
    public var haptic: UIImpactFeedbackGenerator.FeedbackStyle = .medium
    
    //MARK: init
    init(direction: Direction, on: UIViewController?, type: SYBannerType = .float) {
        // Defer to call the didSet method on bannerType
        defer {
            self.bannerType = type
        }
        self.direction = direction
        self.parentViewController = on
        super.init(frame: .zero)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Functions
    internal func postionView() {
        fatalError("postionView(): has not been implemented for BaseNotificationBanner")
    }
    
    internal func positionAnimation(completion: (() -> ())? = nil) {
        UIView.animate(withDuration: self.animationDurationShow, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [.curveLinear, .allowUserInteraction]) {
            switch self.direction {
            case .bottom:
                self.frame.origin.y = UIScreen.main.bounds.size.height - self.bannerInsets.bottom - self.frame.size.height
            case .top:
                self.frame.origin.y = self.bannerInsets.top
            }
        } completion: { _ in
            completion?()
        }
    }
    
    /**
     Places a NotificationBanner on the queue and shows it if its the first one in the queue
     */
    public func show(queuePosition: QueuePosition = .back) {
        self.show(placeOnQueue: true, queuePosition: queuePosition)
    }
    
    /**
     Places a NotificationBanner on the queue if option is selected otherwise shows it immediately
     */
    public func show(placeOnQueue: Bool, queuePosition: QueuePosition = .back) {
        self.postionView()
        guard !isDisplaying else {return}
        
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
    
    /**
     Removes the NotificationBanner from the queue if not displaying
     */
    public func remove() {
        guard !isDisplaying else {return}
        bannerQueue.removeBanner(self)
    }
    
    /**
     Add a TapGesture to the View
     */
    private func addTapGesture() {
        if dismissOnTap {
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.onTapGestureRecognizer(sender:)))
            self.addGestureRecognizer(tapGestureRecognizer)
        }
    }
    
    /**
     Add a SwipeGesture to the View depending on the direction
     */
    internal func addSwipegesture() {
        if dismissOnSwipe {
            let swipeUpGesture = UISwipeGestureRecognizer(target: self, action: #selector(onSwipeGestureRecognizer))
            swipeUpGesture.direction = (self.direction == .bottom) ? .down : .up
            addGestureRecognizer(swipeUpGesture)
        }
    }
    
    /**
     Called when a notification banner is swiped up
     */
    @objc internal dynamic func onSwipeGestureRecognizer() {
        guard isDisplaying else {return}
        didTap?()
        self.dismissView()
        
        onSwipe?()
    }
    
    /**
     Called when a notification banner is tapped
     */
    @objc private func onTapGestureRecognizer(sender: UITapGestureRecognizer) {
        guard isDisplaying else {return}
        didTap?()
        self.dismissView()
    }
}



extension SYBaseBanner {
    /// the parent view to display the banner
    public dynamic var parentView: UIView? {
        get {
            if let vc = parentViewController {
                return  vc.view
            }
            return self.appWindow
        }
    }
    
    /**
     animates the notification banner from the defined direction in
     */
    @objc internal func animateView() {
        guard let superView = parentView else {return}
        self.isDisplaying = true
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
            superView.addSubview(self)
            self.delegate?.notificationBannerWillAppear(self)
            
            UIImpactFeedbackGenerator(style: self.haptic).impactOccurred()
            
            self.positionAnimation {
                self.addTapGesture()
                self.addSwipegesture()
                self.delegate?.notificationBannerDidAppear(self)
                self.hasBeenSeen = true
            }
        }
    }

    /**
     dismisses  the notification banner from the opposite of defined direction
     */
    @objc public func dismissView(_ completion: (() -> ())? = nil) {
        guard !isDismissing else {return}
        self.isDismissing = true
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
            self.delegate?.notificationBannerWillDisappear(self)
            UIView.animate(withDuration: self.animationDurationDisappear, delay: 0, options: [.curveLinear, .allowUserInteraction]) {
                guard self.isDisplaying else {return}
                switch self.direction {
                case .bottom:
                    self.frame.origin.y = UIScreen.main.bounds.size.height + self.frame.size.height
                case .top:
                    self.frame.origin.y = -self.frame.size.height
                }
                
                
            } completion: { _ in
                self.bannerQueue.removeBanner(self)
                self.isDisplaying = false
                self.delegate?.notificationBannerDidDisappear(self)
                self.removeFromSuperview()
                completion?()
            }
        }
    }
}
