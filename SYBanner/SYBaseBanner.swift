//
//  SYBaseBanner.swift
//  SYBanner
//
//  Created by Emre Armagan on 06.04.22.
//

import UIKit

@objc(SYBannerDirection)
public enum Direction : Int {
    case bottom
    case top
    case left
    case right
}

@objc
public enum SYBannerType : Int {
    case custom
    case float
    case stick
}

@objc
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
    @objc
    public private(set) var direction: Direction
    /// Indicates wheter the notification is currently displaying
    @objc public private(set) var isDisplaying = false
    /// Indicates wheter the notification has been already shown
    @objc public private(set) var hasBeenSeen = false
    
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
    @objc
    public weak var parentViewController: UIViewController?
    
    /// The delegate of the notification banner
    @objc
    public weak var delegate: SYBannerDelegate?
    
    /// animation duration of the notification for appearing
    @objc
    public var animationDurationShow: CGFloat       = 0.5
    
    /// animation duration of the notification for disappearing
    @objc
    public var animationDurationDisappear: CGFloat       = 0.5
    
    /// duration for whole long the notification should appear on the screen
    @objc
    public var appearanceDuration: TimeInterval = 5
    
    /// Responsible for positioning and auto managing notification banners
    @objc
    public var bannerQueue: SYBannerQueue = SYBannerQueue.default

    
    /// If false, the banner will not be dismissed until the developer programatically dismisses it
    @objc
    public var autoDismiss: Bool = true {
        didSet {
            if !autoDismiss {
                dismissOnTap = false
                dismissOnSwipe = false
            }
        }
    }
    
    /// If true, notification will dismissed when tapped
    @objc
    public var dismissOnTap: Bool = true
    
    /// If true, notification will dismissed when swiped up
    @objc
    public var dismissOnSwipe: Bool = true
    
    /// Closure that will be executed if the notification banner is swiped up
    @objc
    public var onSwipe: (() -> Void)?
    
    /// Closure that will be executed if the notification banner is tapped
    @objc
    public var didTap: (() -> Void)?
    
    /// The transparency of the background of the notification banner
    @objc
    public var transparency: CGFloat = 1 {
        didSet {
            self.backgroundColor = self.backgroundColor?.withAlphaComponent(transparency)
        }
    }
    
    /// The type of haptic to generate when a banner is displayed
    @objc
    public var haptic: UIImpactFeedbackGenerator.FeedbackStyle = .medium
    
    //MARK: init
    @objc
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
    
    internal func positionFinalFrame(_ animate: Bool = true, completion: (() -> ())? = nil) {
        UIView.animate(withDuration: animate ? self.animationDurationShow : 0, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [.curveLinear, .allowUserInteraction]) {
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
    
    /**
     Places a NotificationBanner on the queue and shows it if its the first one in the queue
     */
    @objc
    public func show(queuePosition: QueuePosition = .back) {
        self.show(placeOnQueue: true, queuePosition: queuePosition)
    }
    
    /**
     Places a NotificationBanner on the queue if option is selected otherwise shows it immediately
     */
    @objc
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
    @objc
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
    @objc
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
            if let willAppear = self.delegate?.notificationBannerWillAppear {
                willAppear(self)
            }
            UIImpactFeedbackGenerator(style: self.haptic).impactOccurred()
            
            self.positionFinalFrame {
                self.addTapGesture()
                self.addSwipegesture()
                if let didAppear = self.delegate?.notificationBannerDidAppear {
                    didAppear(self)
                }
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
            if let willDisappear = self.delegate?.notificationBannerWillDisappear {
                willDisappear(self)
            }
            UIView.animate(withDuration: self.animationDurationDisappear, delay: 0, options: [.curveLinear, .allowUserInteraction]) {
                guard self.isDisplaying else {return}
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
                if let didDisappear = self.delegate?.notificationBannerDidDisappear {
                    didDisappear(self)
                }
                self.removeFromSuperview()
                completion?()
            }
        }
    }
}
