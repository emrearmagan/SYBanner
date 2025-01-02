//
//  SYSimpleBanner.swift
//  SYBanner
//
//  Created by Emre Armagan on 06.04.22.
//

import UIKit

open class SYSimpleBanner: SYBaseBanner {
    // MARK: Properties

    var contentConstraints: [NSLayoutConstraint] = []

    /// message of the notification
    var messageLabel: UILabel = .init()

    /// The message of the notification

    public var message: String {
        didSet {
            updateLabel()
        }
    }

    /// Color of the mesage

    public var messageColor: UIColor = .label {
        didSet {
            updateLabel()
        }
    }

    /// Font of the message

    public var messageFont: UIFont = .systemFont(ofSize: 16) {
        didSet {
            updateLabel()
        }
    }

    /// Insets of the label inside the view

    public var messageInsets: UIEdgeInsets = .init(top: 10, left: 30, bottom: 10, right: 30) {
        didSet {
            setConstraints()
        }
    }

    // MARK: Init

    public convenience init(_ message: String, backgroundColor: UIColor, direction: Direction = .top, on: UIViewController? = nil) {
        self.init(message, color: backgroundColor, direction: direction, on: on)
    }

    public init(_ message: String, color: UIColor?, direction: Direction, type: SYBannerType = .float, on: UIViewController?) {
        self.message = message

        super.init(direction: direction, on: on, type: type)
        backgroundColor = color

        setupView()
        setConstraints()
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.size.height / 2
        layer.masksToBounds = true
    }

    // MARK: Functions

    func updateLabel() {
        messageLabel.font = messageFont
        messageLabel.text = message
        messageLabel.textColor = messageColor
        messageLabel.numberOfLines = 0

        postionView()
        if isDisplaying {
            positionFinalFrame(false)
        }
    }

    func setupView() {
        if !messageLabel.isDescendant(of: self) {
            addSubview(messageLabel)
        }
        updateLabel()

        messageLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    override func postionView() {
        let labelSize = getMessageLabelSize()

        var containerRect = CGRect.zero
        containerRect.size = CGSize(width: labelSize.width + messageInsets.left + messageInsets.right, height: labelSize.height + messageInsets.top + messageInsets.bottom)
        frame = containerRect

        center.x = screenSize.width / 2

        switch direction {
            case .bottom, .top:
                center.x = screenSize.width / 2
                frame.origin.y = direction == .top ? -frame.size.height : screenSize.height

            case .left, .right:
                center.y = screenSize.height / 2
                frame.origin.x = direction == .left ? -frame.size.width : screenSize.width
        }
    }

    func getMessageLabelSize() -> CGSize {
        let containerSize = screenSize.width - (bannerInsets.left + bannerInsets.right)

        var constraintRect = CGSize(width: containerSize, height: .greatestFiniteMagnitude)
        let labelHeight = ceil(message.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: messageFont], context: nil).height)

        constraintRect = CGSize(width: .greatestFiniteMagnitude, height: labelHeight)
        let labelWidth = ceil(message.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: messageFont], context: nil).width)
        return CGSize(width: labelWidth, height: labelHeight)
    }

    /// sets the constraints for the icon and message label
    func setConstraints() {
        NSLayoutConstraint.deactivate(contentConstraints)

        contentConstraints = [
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: messageInsets.left),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -messageInsets.right),
            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: messageInsets.top),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -messageInsets.bottom)
        ]

        NSLayoutConstraint.activate(contentConstraints)
    }
}
