//
//  SYSimpleBanner.swift
//  SYBanner
//
//  Created by Emre Armagan on 06.04.22.
//

import UIKit


open class SYSimpleBanner: SYBaseBanner {
    //MARK: Properties
    /// message of the notification
    private var messageLabel: UILabel = UILabel()

    /// The message of the notification
    public private(set) var message: String
    
    /// Color of the mesage
    public var textColor: UIColor = .white {
        didSet {
            setupView()
        }
    }
    
    /// Font of the message
    public var messageFont: UIFont = .systemFont(ofSize: 16) {
        didSet {
            setupView()
        }
    }
    
    /// Insets of the label inside the view
    public var textInsets: UIEdgeInsets = UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 30) {
        didSet {
            setConstraints()
        }
    }
    
    /// Padding of the banner on each size
    public var padding: CGFloat = 10
    
    
    //MARK: Init
    public convenience init(_ message: String, backgroundColor: UIColor, textColor: UIColor, direction: Direction = .top) {
        self.init(message, color: backgroundColor, textColor: textColor, direction: direction, on: nil)
    }
    
    private init(_ message: String, color: UIColor, textColor: UIColor, direction: Direction, on: UIViewController?) {
        self.message = message
        self.textColor = textColor
        
        super.init(direction: direction, on: on)
        self.backgroundColor = color

        setupView()
        setConstraints()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.size.height / 2
        self.layer.masksToBounds = true
    }
    
    //MARK: Functions
    private func setupView() {
        //label
        messageLabel.font = messageFont
        messageLabel.text = message
        messageLabel.textColor = textColor
        messageLabel.numberOfLines = 0
    }
   
    override func postionView() {
        let labelSize = getLabelSize()
        
        var containerRect = CGRect.zero
        containerRect.size = CGSize(width: labelSize.width + textInsets.left + textInsets.right, height: labelSize.height + textInsets.top + textInsets.bottom)
        
        self.frame = containerRect
        self.center.x = screenSize.width / 2
        self.frame.origin.y = self.direction == .top ? -self.frame.size.height : UIScreen.main.bounds.height
    }
 
    
    private func getLabelSize() -> CGSize {
        let containerSize = screenSize.width - (padding * 2)

        var constraintRect = CGSize(width: containerSize, height: .greatestFiniteMagnitude)
        let labelHeight = ceil(message.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: messageFont], context: nil).height)
    
        constraintRect = CGSize(width: .greatestFiniteMagnitude, height: labelHeight)
        let labelWidth = ceil(message.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: messageFont], context: nil).width)
        return CGSize(width: labelWidth, height: labelHeight)
    }
    
    /**
     sets the constraints for the icon and message label
     */
    private func setConstraints() {
        messageLabel.removeFromSuperview()
        self.addSubview(messageLabel)
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            //messageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: textInsets.left),
            messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -textInsets.right),
            messageLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: textInsets.top),
            messageLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -textInsets.bottom),
        ])
    }
}

