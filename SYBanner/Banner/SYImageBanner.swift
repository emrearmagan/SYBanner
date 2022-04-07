//
//  SYImageBanner.swift
//  SYBanner
//
//  Created by Emre Armagan on 06.04.22.
//

import UIKit

public class SYImageBanner: SYDefaultBanner {
    /// message of the notification
    internal var titleLabel: UILabel = UILabel()
    
    private var title: String
    
    /// icon of the notification
    public var bannerImageView: UIImageView = UIImageView()
    
    /// Image for the notification.
    internal var bannerImage: UIImage
    
    /// Font of the title
    public var titleFont: UIFont = .systemFont(ofSize: 18, weight: .semibold) {
        didSet {
            self.messageLabel.font = messageFont
        }
    }
   
    /// Edge insets of the message label
    public var titleInsets: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10) {
        didSet {
            setConstraints()
        }
    }
    
    public convenience init(_ title: String,_ message: String, icon: UIImage? = nil, image: UIImage, type: SYBannerType, backgroundColor: UIColor, direction: Direction = .top, on: UIViewController? = nil) {
        self.init(title, message, icon: icon, image: image, color: backgroundColor, direction: direction, type: type, on: on)
    }
    
    private init(_ title: String, _ message: String, icon: UIImage?, image: UIImage, color: UIColor, direction: Direction, type: SYBannerType, on: UIViewController?) {
        self.title = title
        self.bannerImage = image
        super.init(message, icon: icon, color: color, direction: direction, type: type, on: on)
        //override the default settings for a more pleasing look
        self.messageFont = .systemFont(ofSize: 16, weight: .regular)
        self.messageInsets = titleInsets
        iconSize = CGSize(width: 25, height: 25)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView() {
        super.setupView()
        
        bannerImageView.image = self.bannerImage
        bannerImageView.contentMode = .scaleAspectFit
        
        //label
        titleLabel.text = title
        titleLabel.font = titleFont
       
        self.addSubview(titleLabel)
        self.addSubview(bannerImageView)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        bannerImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func postionView() {
        let containerSize = screenSize.width - (padding * 2)
       
        let titleRect = CGSize(width: containerSize - (titleInsets.left + titleInsets.right), height: .greatestFiniteMagnitude)
        var titleHeight = ceil((title as NSString).boundingRect(with: titleRect, options: .usesLineFragmentOrigin, attributes: [.font: titleFont], context: nil).height) + titleInsets.top + titleInsets.bottom
        titleHeight = max(titleHeight, iconSize.height)
        
        let messageRect = CGSize(width: containerSize - (messageInsets.left + messageInsets.right), height: .greatestFiniteMagnitude)
        let messageHeight = ceil((message as NSString).boundingRect(with: messageRect, options: .usesLineFragmentOrigin, attributes: [.font: messageFont], context: nil).height) + messageInsets.bottom + messageInsets.top
        
       
        
        var containerRect = CGRect.zero
        containerRect.size = CGSize(width: containerSize, height: bannerImage.size.height + messageHeight + titleHeight)
        self.frame = containerRect.inset(by: UIEdgeInsets(top: 0, left: padding, bottom: 0, right: -padding))
        self.frame.origin.y = self.direction == .top ? -self.frame.size.height : UIScreen.main.bounds.height
    }
    
    
    /**
     sets the constraints for the icon and message label
     */
    override func setConstraints() {
        NSLayoutConstraint.deactivate(contentConstraints)
        contentConstraints = [
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: titleInsets.left),
            imageView.centerYAnchor.constraint(equalTo: self.titleLabel.centerYAnchor),
            
            imageView.heightAnchor.constraint(equalToConstant: iconSize.height),
            imageView.widthAnchor.constraint(equalToConstant: iconSize.width),
            
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: titleInsets.top),
            titleLabel.leadingAnchor.constraint(equalTo: self.imageView.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -titleInsets.right),
            
            
            bannerImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            bannerImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            bannerImageView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: titleInsets.bottom),
            
            messageLabel.topAnchor.constraint(equalTo: bannerImageView.bottomAnchor, constant: messageInsets.top),
            messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: messageInsets.left),
            messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -messageInsets.right)
        ]
        
        NSLayoutConstraint.activate(contentConstraints)
    }
}
