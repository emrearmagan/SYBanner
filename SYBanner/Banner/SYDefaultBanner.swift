//
//  SYDefaultBanner.swift
//  SYBanner
//
//  Created by Emre Armagan on 06.04.22.
//

import UIKit

public class SYDefaultBanner: SYSimpleBanner {
    //MARK: Properties
    /// icon of the notification
    public var imageView: UIImageView = UIImageView()
    
    /// Custom icon for the notification. If none is set the icon of the Notification type will be selected
    internal var customIcon: UIImage?
    
    /// Custom icon for the notification. If none is set the icon of the Notification type will be selected
    internal var customBackgroundColor: UIColor?
 
    /// Size of the icon
    public var iconSize: CGSize = CGSize(width: 30, height: 30) {
        didSet {
            setConstraints()
        }
    }
 
    /// Defines the notification type
    internal var style: SYBannerStyle
    
    //MARK: Init
    public convenience init(_ message: String, icon: UIImage?, backgroundColor: UIColor, direction: Direction = .bottom, type: SYBannerType = .float) {
        self.init(message, icon: icon, color: backgroundColor, direction: direction, style: .success, type: type, on: nil)
    }
    
    public convenience init(_ message: String, direction: Direction = .bottom, style: SYBannerStyle, type: SYBannerType = .float, on: UIViewController? = nil) {
        self.init(message, icon: nil, color: nil, direction: direction, style: style, type: type, on: on)
    }
    
    public convenience init(_ message: String, iconName: String, direction: Direction, style: SYBannerStyle, type: SYBannerType = .float, on: UIViewController? = nil) {
        self.init(message, icon: UIImage(named: iconName), color: nil, direction: direction, style: style, type: type, on: on)
    }
    
    internal init(_ message: String, icon: UIImage? = nil, color: UIColor?, direction: Direction, style: SYBannerStyle, type: SYBannerType, on: UIViewController?) {
        self.style = style
        self.customIcon = icon
        self.customBackgroundColor = color
        
        super.init(message, color: color, direction: direction, type: type, on: on)
        self.messageInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
    }
    
    //MARK: Functions
    override internal func setupView() {
        super.setupView()
        
        if let color = customBackgroundColor {
            self.backgroundColor = color
        } else {
            self.backgroundColor = style.color
        }
        
        //image
        if let icon = customIcon {
            imageView.image = icon
        } else {
            imageView.image = style.image ?? nil
            imageView.tintColor = .white
        }
        imageView.contentMode = .scaleAspectFit
        
        self.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        if self.bannerType == .stick && direction == .top {
            self.messageInsets.top = (self.parentView?.safeAreaInsets.top ?? messageInsets.top)
        }
    }
    
    override func postionView() {
        let containerSize = screenSize.width - (bannerInsets.left + bannerInsets.right)
       
        let labelRect = CGSize(width: containerSize - iconSize.width - (messageInsets.left * 2 + messageInsets.right), height: .greatestFiniteMagnitude)
        var labelHeight = ceil((message as NSString).boundingRect(with: labelRect, options: .usesLineFragmentOrigin, attributes: [.font: messageFont], context: nil).height)
        labelHeight = max(labelHeight, iconSize.height)
        
        var containerRect = CGRect.zero
        containerRect.size = CGSize(width: containerSize, height: labelHeight + (messageInsets.top + messageInsets.bottom))
        self.frame = containerRect.inset(by: .init(top: 0, left: bannerInsets.left, bottom: 0, right: -bannerInsets.right))
        if bannerType == .stick {
            self.frame = self.frame.inset(by: .init(top: 0, left: 0, bottom: (-(safeArea?.top ?? 0)), right: 0))
        }
        self.frame.origin.y = self.direction == .top ? -self.frame.size.height : UIScreen.main.bounds.height
    }
    
    
    override internal func setConstraints() {
        NSLayoutConstraint.deactivate(contentConstraints)
        contentConstraints = [
            imageView.heightAnchor.constraint(equalToConstant: iconSize.height),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: self.messageInsets.left),
            
            messageLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            //messageLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -messageInsets.bottom),
            messageLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: messageInsets.left),
            messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -messageInsets.right),
        ]
        
        let this = (bannerType == .stick && direction == .top) ? (safeArea?.top ?? 0) : 0
        contentConstraints.append(imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: self.messageInsets.top + this))
        
        if style != .none {
            contentConstraints.append(imageView.widthAnchor.constraint(equalToConstant: iconSize.width))
        } else {
            contentConstraints.append(imageView.widthAnchor.constraint(equalToConstant: 0))
        }
        
        NSLayoutConstraint.activate(contentConstraints)
    }
}
