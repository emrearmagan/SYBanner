//
//  SYDefaultBanner.swift
//  SYBanner
//
//  Created by Emre Armagan on 06.04.22.
//

import UIKit

public class SYDefaultBanner: SYSimpleBanner {
    // MARK: Properties

    /// icon of the notification
    @objc
    public var imageView: UIImageView = .init()

    /// Custom icon for the notification. If none is set the icon of the Notification type will be selected
    var customIcon: UIImage?

    /// Custom icon for the notification. If none is set the icon of the Notification type will be selected
    var customBackgroundColor: UIColor?

    /// Size of the icon
    @objc
    public var iconSize: CGSize = .init(width: 30, height: 30) {
        didSet {
            setConstraints()
        }
    }

    /// Defines the notification type
    var style: SYBannerStyle

    // MARK: Init

    @objc
    public convenience init(_ message: String, icon: UIImage?, backgroundColor: UIColor, direction: Direction = .bottom, type: SYBannerType = .float) {
        self.init(message, icon: icon, color: backgroundColor, direction: direction, style: .success, type: type, on: nil)
    }

    @objc
    public convenience init(_ message: String, direction: Direction = .bottom, style: SYBannerStyle, type: SYBannerType = .float, on: UIViewController? = nil) {
        self.init(message, icon: nil, color: nil, direction: direction, style: style, type: type, on: on)
    }

    @objc
    public convenience init(_ message: String, iconName: String, direction: Direction, style: SYBannerStyle, type: SYBannerType = .float, on: UIViewController? = nil) {
        self.init(message, icon: UIImage(named: iconName), color: nil, direction: direction, style: style, type: type, on: on)
    }

    @objc
    public init(_ message: String, icon: UIImage? = nil, color: UIColor?, direction: Direction, style: SYBannerStyle, type: SYBannerType, on: UIViewController?) {
        self.style = style
        customIcon = icon
        customBackgroundColor = color

        super.init(message, color: color, direction: direction, type: type, on: on)
        messageInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }

    @available(*, unavailable)
    @objc
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 10
        layer.masksToBounds = true
    }

    // MARK: Functions

    override func setupView() {
        super.setupView()

        if let color = customBackgroundColor {
            backgroundColor = color
        } else {
            backgroundColor = style.color
        }

        // image
        if let icon = customIcon {
            imageView.image = icon
        } else {
            imageView.image = style.image ?? nil
            imageView.tintColor = .white
        }
        imageView.contentMode = .scaleAspectFit

        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false

        if bannerType == .stick && direction == .top {
            messageInsets.top = (parentView?.safeAreaInsets.top ?? messageInsets.top)
        }
    }

    override func postionView() {
        let containerSize = screenSize.width - (bannerInsets.left + bannerInsets.right)

        let labelRect = CGSize(width: containerSize - iconSize.width - (messageInsets.left * 2 + messageInsets.right), height: .greatestFiniteMagnitude)
        var labelHeight = ceil((message as NSString).boundingRect(with: labelRect, options: .usesLineFragmentOrigin, attributes: [.font: messageFont], context: nil).height)
        labelHeight = max(labelHeight, iconSize.height)

        var containerRect = CGRect.zero
        containerRect.size = CGSize(width: containerSize, height: labelHeight + (messageInsets.top + messageInsets.bottom))
        frame = containerRect.inset(by: .init(top: 0, left: bannerInsets.left, bottom: 0, right: -bannerInsets.right))
        if bannerType == .stick {
            frame = frame.inset(by: .init(top: 0, left: 0, bottom: -(safeArea?.top ?? 0), right: 0))
        }
        frame.origin.y = direction == .top ? -frame.size.height : UIScreen.main.bounds.height
    }

    override func setConstraints() {
        NSLayoutConstraint.deactivate(contentConstraints)
        contentConstraints = [
            imageView.heightAnchor.constraint(equalToConstant: iconSize.height),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: messageInsets.left),

            messageLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            // messageLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -messageInsets.bottom),
            messageLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: messageInsets.left),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -messageInsets.right)
        ]

        let this = (bannerType == .stick && direction == .top) ? (safeArea?.top ?? 0) : 0
        contentConstraints.append(imageView.topAnchor.constraint(equalTo: topAnchor, constant: messageInsets.top + this))

        if style != .none {
            contentConstraints.append(imageView.widthAnchor.constraint(equalToConstant: iconSize.width))
        } else {
            contentConstraints.append(imageView.widthAnchor.constraint(equalToConstant: 0))
        }

        NSLayoutConstraint.activate(contentConstraints)
    }
}
