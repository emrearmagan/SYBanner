//
//  SYDefaultBanner.swift
//  SYBanner
//
//  Created by Emre Armagan on 06.04.22.
//

import UIKit

public class SYDefaultBanner: SYBaseBanner {
    //MARK: Properties
    /// icon of the notification
    public var imageView: UIImageView = UIImageView()
    
    /// Custom icon for the notification. If none is set the icon of the Notification type will be selected
    internal var customIcon: UIImage?
    
    /// Custom icon for the notification. If none is set the icon of the Notification type will be selected
    internal var customBackgroundColor: UIColor?
    
    /// message of the notification
    internal var messageLabel: UILabel = UILabel()
    
    internal var contentConstraints: [NSLayoutConstraint] = []
    
    /// The message of the notification
    internal var message: String
    
    /// Size of the icon
    public var iconSize: CGSize = CGSize(width: 30, height: 30) {
        didSet {
            setConstraints()
        }
    }
    
    /// Edge insets of the message label
    public var messageInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10) {
        didSet {
            setConstraints()
        }
    }
    
    /// Left padding of the image view
    public var imagePadding: CGFloat = 10 {
        didSet {
            setConstraints()
        }
    }
    
    /// Defines the notification type
    public var type: SYBannerType
    
    /// Font of the message
    open var messageFont: UIFont = .systemFont(ofSize: 16, weight: .semibold) {
        didSet {
            self.messageLabel.font = messageFont
        }
    }
   
    
    /// Color of the message
    public var messageColor: UIColor = .label {
        didSet {
            self.messageLabel.textColor = messageColor
        }
    }
    
    /// Padding of the banner on each size
    public var padding: CGFloat = 10
    
    //MARK: Init
    public convenience init(_ message: String, icon: UIImage?, backgroundColor: UIColor, direction: Direction = .bottom) {
        self.init(message, icon: icon, color: backgroundColor, direction: direction, type: .success, on: nil)
    }
    
    public convenience init(_ message: String, direction: Direction = .bottom, type: SYBannerType, on: UIViewController? = nil) {
        self.init(message, icon: nil, color: nil, direction: direction, type: type, on: on)
    }
    
    public convenience init(_ message: String, iconName: String, direction: Direction, type: SYBannerType, on: UIViewController? = nil) {
        self.init(message, icon: UIImage(named: iconName), color: nil, direction: direction, type: type, on: on)
    }
    
    internal init(_ message: String, icon: UIImage? = nil, color: UIColor?, direction: Direction, type: SYBannerType, on: UIViewController?) {
        self.type = type
        self.customIcon = icon
        self.customBackgroundColor = color
        self.message = message
        super.init(direction: direction, on: on)

        setupView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Functions
    internal func setupView() {
        if let color = customBackgroundColor {
            self.backgroundColor = color
        } else {
            self.backgroundColor = type.color
        }
        
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        
        //image
        if let icon = customIcon {
            imageView.image = icon
        } else {
            imageView.image = type.image ?? nil
            imageView.tintColor = .white
        }
        imageView.contentMode = .scaleAspectFit
        //label
        messageLabel.font = messageFont
        messageLabel.text = message
        messageLabel.textColor = messageColor
        messageLabel.numberOfLines = 0
        
        self.addSubview(messageLabel)
        self.addSubview(imageView)

        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func postionView() {
        let containerSize = screenSize.width - (padding * 2)
       
        let labelRect = CGSize(width: containerSize - iconSize.width - (imagePadding + messageInsets.left + messageInsets.right), height: .greatestFiniteMagnitude)
        var labelHeight = ceil((message as NSString).boundingRect(with: labelRect, options: .usesLineFragmentOrigin, attributes: [.font: messageFont], context: nil).height)
        labelHeight = max(labelHeight, iconSize.height)
        
        var containerRect = CGRect.zero
        containerRect.size = CGSize(width: containerSize, height: labelHeight + (messageInsets.left * 2))
        self.frame = containerRect.inset(by: UIEdgeInsets(top: 0, left: padding, bottom: 0, right: -padding))
        self.frame.origin.y = self.direction == .top ? -self.frame.size.height : UIScreen.main.bounds.height
    }
    
    
    /**
     sets the constraints for the icon and message label
     */
    internal func setConstraints() {
        
        NSLayoutConstraint.deactivate(contentConstraints)
        contentConstraints = [
            messageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            messageLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: messageInsets.left),
            messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -messageInsets.right),
            
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: imagePadding),
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            imageView.heightAnchor.constraint(equalToConstant: iconSize.height),
            imageView.widthAnchor.constraint(equalToConstant: iconSize.width)
        ]
        
        NSLayoutConstraint.activate(contentConstraints)
    }
}
