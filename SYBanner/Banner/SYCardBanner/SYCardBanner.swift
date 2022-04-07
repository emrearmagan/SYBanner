//
//  SYCardBanner.swift
//  SYBanner
//
//  Created by Emre Armagan on 07.04.22.
//

import UIKit

public enum SYCardBannerOptions {
    case backgroundColor(UIColor)
    case buttonsHeight(CGFloat)
    case cornerRounding(CGFloat)
    case titleFont(UIFont)
    case titleColor(UIColor)
    case subTitleFont(UIFont)
    case subTitleColor(UIColor)
    case tintColor(UIColor)
    case customView(UIView)
    case customViewInsets(UIEdgeInsets)
    case contentInsets(UIEdgeInsets)
    case showExitButton(Bool)
    case buttonAxis(NSLayoutConstraint.Axis)
}

public class SYCardBanner: SYBaseBanner {
    //MARK: Properties
    ///Constraints for the content
    private var labelConstraints: [NSLayoutConstraint] = []
    private var customViewConstraints: [NSLayoutConstraint] = []
    private var stackConstraints: [NSLayoutConstraint] = []
    
    /// The default origin of the view. Will be set once the view has been positioned
    private var defaultOrigin: CGFloat = 0
    
    /// Transparent view for the background
    private lazy var transparentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        view.alpha = 0
        return view
    }()
    
    private var _buttonsHeight: CGFloat = 45 {
        didSet { refreshView() }
    }
    
    private var _customViewInsets: UIEdgeInsets = UIEdgeInsets(top: 21, left: 0, bottom: 21, right: 0) {
        didSet { refreshView() }
    }
    
    private var _contentInsets: UIEdgeInsets = UIEdgeInsets(top: 38, left: 21, bottom: 38, right: 28) {
        didSet { refreshView() }
    }

    
    private var buttonCount: Int {
        guard buttonsStackView.isDescendant(of: self) else { return 0 }
        return buttonsStackView.arrangedSubviews.count
    }
    
    private var hasButtons: Bool {
        guard buttonsStackView.isDescendant(of: self) else { return false }
        return !buttonsStackView.arrangedSubviews.isEmpty
    }
    
    private var _stackHeight: CGFloat {
      return buttonsStackView.axis == .vertical ? (buttonsHeight * CGFloat(buttonCount)) : buttonsHeight
    }
    
    private(set) var titleLabel = UILabel()
    private(set) var subtitleLabel = UILabel()
    private(set) var buttonsStackView = UIStackView()
    
    private var exitButtonButtonSize = CGSize(width: 9, height: 9)
    private lazy var exitButtonReact: CGRect = {
        return CGRect(origin: CGPoint(x: self.frame.width - 21 - exitButtonButtonSize.width, y: 16 + exitButtonButtonSize.height), size: exitButtonButtonSize)
    }()
    
    /// The number of drag necessary for the view to be dismissed. Only works if isDismissable is set to true
    public var dismissableOrigin: CGFloat = 50
    
    //TODO: Maye specify a bound
    /// If true, the banner can be moved around.
    public var isDraggable: Bool = true
    ///  If true, the banner will be dismissed when the amount of drag specified in dismissableOrigin has been reached
    public var isDismissable: Bool = true
    
    /// If set to true, a exit button will be drawn on the top right corner
    public var addDismissButton: Bool = false {
        didSet {
            self.setNeedsDisplay()
        }
    }
    /// The custom view in the banner
    public var customView: UIView? {
        didSet {
            if let oldValue = oldValue {
                oldValue.removeFromSuperview()
            }
            refreshView()
        }
    }

    /// Closure that will be executed if a button is tapped
    public var didTapButton: ((_ : SYCardBannerButton) -> ())?
    /// Closure that will be executed if the exit button is tapped
    public var didTapExitButton: (() -> ())?
    
    //MARK: Lifecycle
    public convenience init(title: String, subtitle: String, backgroundColor: UIColor, direction: Direction = .bottom, buttons: [SYCardBannerButton] = []) {
        self.init(title, subtitle: subtitle, color: backgroundColor, direction: direction, buttons: buttons, on: nil)
        
    }
    
    private init(_ title: String, subtitle: String, color: UIColor, direction: Direction, buttons: [SYCardBannerButton], on: UIViewController?) {
        super.init(direction: direction, on: on)
        self.setTitle(title)
        self.setSubTitle(subtitle)
        buttons.forEach { b in
            b.addTarget(self, action: #selector(self.didTapButton(_:)), for: .touchUpInside)
            buttonsStackView.addArrangedSubview(b)
        }
        
        self.autoDismiss = false
        self.backgroundColor = color
        self.layer.cornerRadius = 20
        setupUI()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
    }

    //MARK: Functions
    public func setTitle(_ title: String?) {
        if let title = title {
            self.titleLabel.text = title
        }
    }
    
    public func setSubTitle(_ subTitle: String?) {
        if let subTitle = subTitle {
            self.subtitleLabel.text = subTitle
        }
    }
    
    func setCustomView(_ customView: UIView?) {
        guard let customView = customView else { return }
        self.customView = customView
        self.addSubview(customView)
        refreshView()
    }
    
    public func addButton(_ button: SYCardBannerButton) {
        button.addTarget(self, action: #selector(self.didTapButton(_:)), for: .touchUpInside)
        buttonsStackView.addArrangedSubview(button)
        refreshView()
    }
    
    @objc private func didTapButton(_ button: SYCardBannerButton) {
        if button.style == .dismiss {
            self.dismissView()
        }
        didTapButton?(button)
    }
    
    override func postionView() {
        let containerSize = screenSize.width
        
        let labelRect = CGSize(width: containerSize - (_contentInsets.left + _contentInsets.right), height: .greatestFiniteMagnitude)
        let titleHeight = ceil(("How to use" as NSString).boundingRect(with: labelRect, options: .usesLineFragmentOrigin, attributes: [.font: self.titleFont], context: nil).height)
        let subTitleHeight = ceil(("This App is part of my bachelor thesis and is used to generate data." as NSString).boundingRect(with: labelRect, options: .usesLineFragmentOrigin, attributes: [.font: self.subtitleFont], context: nil).height)
        
        let headerHeight = (titleHeight + subTitleHeight) + _contentInsets.top + 16
        
        let totalHeight = headerHeight + _customViewInsets.top + (self.customView?.frame.size.height ?? 0) + _customViewInsets.bottom + buttonsHeight + _contentInsets.bottom
        var containerRect = CGRect.zero
        containerRect.size = CGSize(width: containerSize, height: totalHeight)
        
        self.frame = containerRect.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        self.frame.origin.y = self.direction == .top ? -self.frame.size.height : UIScreen.main.bounds.height
        self.defaultOrigin = self.frame.origin.y - self.frame.height
    }
    
    override func positionAnimation(completion: (() -> ())? = nil) {
        UIView.animate(withDuration: self.animationDurationShow, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: [.curveLinear, .allowUserInteraction]) {
            switch self.direction {
            case .bottom:
                self.frame.origin.y = UIScreen.main.bounds.size.height - self.frame.size.height
            case .top:
                self.frame.origin.y = 0
            }
        } completion: { _ in
            completion?()
        }
    }
 
    
    override func animateView() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
            guard let parentView = self.parentView else {return}
            
            self.transparentView.frame =  parentView.frame
            parentView.addSubview(self.transparentView)
            self.transparentView.alpha = 0.7
        }
        
        super.animateView()
    }
    
    override public func dismissView() {
        self.transparentView.alpha = 0
        self.transparentView.removeFromSuperview()
        super.dismissView()
    }
}

//MARK: - UI
extension SYCardBanner {
    private func setupUI() {
        self.addSubview(buttonsStackView)
        self.addSubview(titleLabel)
        self.addSubview(subtitleLabel)
        self.addSubview(buttonsStackView)
   
        
        titleLabel.font = .systemFont(ofSize: 30, weight: .bold)
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        
        subtitleLabel.font = .systemFont(ofSize: 13, weight: .medium)
        subtitleLabel.textColor = .gray
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textAlignment = .center
        
        buttonsStackView.axis = .horizontal
        buttonsStackView.spacing = 8
        buttonsStackView.distribution = .fillEqually
    
        refreshView()
        setupPanGesture()
    }
    
    private func refreshView() {
        updateLabelConstraints()
        updateCustomViewConstraints()
        updateButtonsStackViewConstraints()
    }
    
    private func updateLabelConstraints() {
        NSLayoutConstraint.deactivate(labelConstraints)
        guard titleLabel.isDescendant(of: self), subtitleLabel.isDescendant(of: self) else { return }
        
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
       
        labelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: self._contentInsets.top),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: self._contentInsets.left),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -self._contentInsets.right),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            subtitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: self._contentInsets.left),
            subtitleLabel.trailingAnchor.constraint(equalTo: self.titleLabel.trailingAnchor),
        ]
        
        
        NSLayoutConstraint.activate(labelConstraints)
    }
    
    private func updateCustomViewConstraints() {
        guard let customView = customView else { return }
        NSLayoutConstraint.deactivate(customViewConstraints)
        
        customView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(customView)
        customViewConstraints = [
            customView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: self._contentInsets.left + self._customViewInsets.left),
            customView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -self._contentInsets.right +  self._customViewInsets.right),
            customView.topAnchor.constraint(equalTo: self.subtitleLabel.bottomAnchor, constant:  self._customViewInsets.top),
        ]
        
        NSLayoutConstraint.activate(customViewConstraints)
    }
    
    private func updateButtonsStackViewConstraints() {
        NSLayoutConstraint.deactivate(stackConstraints)
        
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackConstraints = [
            buttonsStackView.leadingAnchor.constraint(equalTo: self.titleLabel.leadingAnchor),
            buttonsStackView.trailingAnchor.constraint(equalTo: self.titleLabel.trailingAnchor),
            buttonsStackView.heightAnchor.constraint(equalToConstant: hasButtons ? _stackHeight: 0),
            buttonsStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -self._contentInsets.bottom),
        ]
        
        
        if let customView = customView {
            stackConstraints.append(buttonsStackView.topAnchor.constraint(equalTo: customView.bottomAnchor, constant: self._customViewInsets.bottom))
        } else {
            stackConstraints.append(buttonsStackView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 16))
        }
        
        NSLayoutConstraint.activate(stackConstraints)
    }
}

//MARK: - Exit button
extension SYCardBanner {
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard addDismissButton else {return}
        
        if let touch = touches.first {
            let point = touch.location(in: self)
            let size = self.exitButtonButtonSize
            let validReact = self.exitButtonReact.inset(by: UIEdgeInsets(top: -size.height, left: -size.width, bottom: -size.height, right: -size.width))
            if validReact.contains(point) {
                self.dismissView()
                self.didTapExitButton?()
            }
            
        }
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard addDismissButton else {return}
        let aPath = UIBezierPath()
        
        aPath.move(to: CGPoint(x: self.exitButtonReact.minX, y: self.exitButtonReact.minY))
        aPath.addLine(to: CGPoint(x: self.exitButtonReact.maxX, y: self.exitButtonReact.maxY))
        aPath.close()
        
        aPath.move(to: CGPoint(x: self.exitButtonReact.maxX, y: self.exitButtonReact.minY))
        aPath.addLine(to: CGPoint(x: self.exitButtonReact.minX, y: self.exitButtonReact.maxY))
        aPath.close()

        UIColor.gray.set()
        aPath.lineJoinStyle = .round
        aPath.lineWidth = 2
        aPath.stroke()
    }
}

// MARK: - Appearance
extension SYCardBanner {
    public func setBannerOptions(_ options: [SYCardBannerOptions]) {
        for option in options {
            switch option {
            case .customView(let view):
                self.customView = view
            case .buttonsHeight(let height):
                self._buttonsHeight = height
            case .cornerRounding(let cornerRadius):
                self.cornerRadius = cornerRadius
            case .titleFont(let font):
                self.titleFont = font
            case .titleColor(let color):
                self.titleTextColor = color
            case .subTitleFont(let font):
                self.subtitleFont = font
            case .subTitleColor(let color):
                self.subtitleTextColor = color
            case .tintColor(let tintColor):
                self.tintColor = tintColor
            case .customViewInsets(let insets):
                self.customViewInsets = insets
            case .contentInsets(let insets):
                self.contentInsets = insets
            case .showExitButton(let value):
                self.addDismissButton = value
            case .backgroundColor(let color):
                self.backgroundColor = color
            case .buttonAxis(let value):
                self.buttonsAxis = value
            }
            
        }
    }
    
    /// height of the buttons
    @objc public dynamic var contentInsets: UIEdgeInsets {
        get { return _contentInsets }
        set { _contentInsets = newValue }
    }
    
    /// Dialog view corner radius
    @objc public dynamic var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
    
   
    /// Title font
    @objc public dynamic var titleFont: UIFont {
        get { return titleLabel.font }
        set { titleLabel.font = newValue }
    }
    
    /// Title text color
    @objc public dynamic var titleTextColor: UIColor {
        get { return titleLabel.textColor }
        set { titleLabel.textColor = newValue }
    }
    
    /// Subtitle font
    @objc public dynamic var subtitleFont: UIFont {
        get { return subtitleLabel.font }
        set { subtitleLabel.font = newValue }
    }
    
    /// Subtitle text color
    @objc public dynamic var subtitleTextColor: UIColor {
        get { return subtitleLabel.textColor }
        set { subtitleLabel.textColor = newValue }
    }
    
    /// inset of the CustomView
    @objc public dynamic var customViewInsets: UIEdgeInsets {
        get { return _customViewInsets }
        set { _customViewInsets = newValue }
    }
    
    /// height of the buttons
    @objc public dynamic var buttonsHeight: CGFloat {
        get { return _buttonsHeight }
        set { _buttonsHeight = newValue }
    }
    
    /// Margin inset between buttons
    @objc public dynamic var buttonsSpace: CGFloat {
        get { return buttonsStackView.spacing }
        set { buttonsStackView.spacing = newValue }
    }
    
    /// Buttons distribution in stack view
    @objc public dynamic var buttonsDistribution: UIStackView.Distribution {
        get { return buttonsStackView.distribution }
        set { buttonsStackView.distribution = newValue }
    }
    
    /// Buttons aligns in stack view
    @objc public dynamic var buttonsAligment: UIStackView.Alignment {
        get { return buttonsStackView.alignment }
        set { buttonsStackView.alignment = newValue }
    }
    
    /// Buttons axis in stack view
    @objc public dynamic var buttonsAxis: NSLayoutConstraint.Axis {
        get { return buttonsStackView.axis }
        set {
            buttonsStackView.axis = newValue
            refreshView()
        }
    }
}

//MARK: - Pangesture
extension SYCardBanner {
    func setupPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(gesture:)))
        // change to false to immediately listen on gesture movement
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        self.addGestureRecognizer(panGesture)
    }
    
    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
        guard isDraggable else {return}
        let translation = gesture.translation(in: self)
        gesture.setTranslation(CGPoint.zero, in: self)
        
        var isDraggingDown = false
        // get drag direction
        if translation.y != 0 {
            isDraggingDown = translation.y > 0
        }
        //print("\(translation.y) - \(isDraggingDown ? "going down" : "going up")")
        
        let originY = self.frame.origin.y
        let newOrigin = originY + translation.y
     
        switch gesture.state {
        case .changed:
            let originUp: CGFloat = defaultOrigin - dismissableOrigin

            if (newOrigin > originUp && !isDraggingDown) {
                self.frame.origin.y = newOrigin
                //self.layoutIfNeeded()
            } else if isDraggingDown {
                self.frame.origin.y = newOrigin
                //self.layoutIfNeeded()
            }
        case .ended:
            //1: If new origin is below the default, dismiss view
            if newOrigin > defaultOrigin + dismissableOrigin && isDismissable {
                self.dismissView()
            }
            // 2: If new origin is below default, animate back to default
            else if newOrigin > defaultOrigin {
                self.positionAnimation()
            }
            // 3: If new origin is above the origin and going up, set to back to default
            else if newOrigin > defaultOrigin - dismissableOrigin && !isDraggingDown {
                self.positionAnimation()
            }
            break
        default:
            break
        }
    }
}
