//
//  NotiflyCard.swift
//  Notifly
//
//  Created by Emre Armagan on 07.04.22.
//

import UIKit

// TODO: Use Notifly.Configuration
public class NotiflyCard: NotiflyBase {
    // MARK: Properties

    /// Constraints for the content
    private var labelConstraints: [NSLayoutConstraint] = []
    private var customViewConstraints: [NSLayoutConstraint] = []
    private var stackConstraints: [NSLayoutConstraint] = []

    private var _buttonsHeight: CGFloat = 45 {
        didSet { refreshView() }
    }

    private var _customViewInsets: UIEdgeInsets = .init(top: 21, left: 0, bottom: 21, right: 0) {
        didSet { refreshView() }
    }

    private var _contentInsets: UIEdgeInsets = .all(16) {
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
        if hasButtons {
            return buttonsStackView.axis == .vertical ? (buttonsHeight * CGFloat(buttonCount) + buttonsStackView.spacing) : buttonsHeight
        }

        return 0
    }

    public private(set) var titleLabel = UILabel()
    public private(set) var subtitleLabel = UILabel()

    private(set) var buttonsStackView = UIStackView()

    private lazy var exitButtonReact: CGRect = .init(origin: CGPoint(x: self.frame.width - 21 - exitButtonSize.width, y: 16 + exitButtonSize.height), size: exitButtonSize)

    /// Spacing between the title and subtitle
    public var titleSubtitleSpacing: CGFloat = 8 {
        didSet {
            refreshView()
        }
    }

    /// The number of drags necessary for the view to be dismissed. Only works if isDismissable is set to true
    public var dismissableOrigin: CGFloat = 100

    /// If set to true, an exit button will be drawn on the top right corner
    public var addExitButton: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }

    /// The size of the top right exit button. Only visible if addExitButton is true
    public var exitButtonSize = CGSize(width: 9, height: 9) {
        didSet {
            setNeedsDisplay()
        }
    }

    /// The custom view in the notification
    public var customView: UIView? {
        didSet {
            if let oldValue = oldValue {
                oldValue.removeFromSuperview()
            }
            refreshView()
        }
    }

    /// Closure that will be executed if a button is tapped
    public var didTapButton: ((_: NotiflyCardButton) -> Void)?
    /// Closure that will be executed if the exit button is tapped
    public var didTapExitButton: (() -> Void)?

    // MARK: Lifecycle

    public convenience init(title: String? = nil,
                            subtitle: String? = nil,
                            direction: NotiflyDirection = .bottom,
                            queue: NotiflyQueue = .default,
                            buttons: [NotiflyCardButton] = []) {
        self.init(title, subtitle: subtitle, direction: direction, queue: queue, buttons: buttons, on: nil)
    }

    private init(_ title: String?,
                 subtitle: String?,
                 direction: NotiflyDirection,
                 queue: NotiflyQueue,
                 buttons: [NotiflyCardButton],
                 on: UIViewController?) {
        super.init(direction: direction, queue: queue, on: on)
        setTitle(title)
        setSubTitle(subtitle)
        for b in buttons {
            b.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
            buttonsStackView.addArrangedSubview(b)
        }

        cornerRadius = 20
        setupUI()
    }

    @available(*, unavailable)
    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func preferredContentSize() -> CGSize {
        return systemLayoutSizeFitting(preferredContainerSize, withHorizontalFittingPriority: .defaultHigh, verticalFittingPriority: .fittingSizeLevel)
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
    }

    // MARK: Functions

    public func setTitle(_ title: String?) {
        if let title = title {
            titleLabel.text = title
        }
    }

    public func setSubTitle(_ subTitle: String?) {
        if let subTitle = subTitle {
            subtitleLabel.text = subTitle
        }
    }

    func setCustomView(_ customView: UIView?) {
        guard let customView = customView else { return }
        self.customView = customView
        addSubview(customView)
        refreshView()
    }

    public func addButton(_ button: NotiflyCardButton) {
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        buttonsStackView.addArrangedSubview(button)
        refreshView()
    }

    @objc private func didTapButton(_ button: NotiflyCardButton) {
        if button.style == .dismiss {
            dismiss()
        }
        didTapButton?(button)
    }
}

// MARK: - UI

extension NotiflyCard {
    private func setupUI() {
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(buttonsStackView)

        titleLabel.font = .systemFont(ofSize: 30, weight: .bold)
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0

        subtitleLabel.font = .systemFont(ofSize: 13, weight: .medium)
        subtitleLabel.textColor = .gray
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textAlignment = .center

        buttonsStackView.axis = .horizontal
        buttonsStackView.spacing = 8
        buttonsStackView.distribution = .fillEqually

        refreshView()
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
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: _contentInsets.top),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: _contentInsets.left),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -_contentInsets.right),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: titleSubtitleSpacing),
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: _contentInsets.left),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
        ]

        NSLayoutConstraint.activate(labelConstraints)
    }

    private func updateCustomViewConstraints() {
        NSLayoutConstraint.deactivate(customViewConstraints)

        customView?.removeFromSuperview()
        if let customView = customView {
            customView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(customView)
            customViewConstraints = [
                customView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: _contentInsets.left + _customViewInsets.left),
                customView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -_contentInsets.right - _customViewInsets.right),
                customView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: _customViewInsets.top),
                customView.bottomAnchor.constraint(equalTo: buttonsStackView.topAnchor, constant: -_customViewInsets.bottom),

                // Set a fixed height for the custom view
                customView.heightAnchor.constraint(equalToConstant: customView.frame.size.height)
            ]
        }

        NSLayoutConstraint.activate(customViewConstraints)
    }

    private func updateButtonsStackViewConstraints() {
        NSLayoutConstraint.deactivate(stackConstraints)

        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false

        if let customView {
            stackConstraints = [
                buttonsStackView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
                buttonsStackView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
                buttonsStackView.heightAnchor.constraint(equalToConstant: _stackHeight),
                buttonsStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -_contentInsets.bottom)
            ]
        } else {
            stackConstraints = [
                buttonsStackView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
                buttonsStackView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
                buttonsStackView.heightAnchor.constraint(equalToConstant: _stackHeight),
                buttonsStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -_contentInsets.bottom),
                buttonsStackView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: contentInsets.bottom)
            ]
        }
        NSLayoutConstraint.activate(stackConstraints)
    }
}

// MARK: - Exit button

public extension NotiflyCard {
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard addExitButton else { return }

        if let touch = touches.first {
            let point = touch.location(in: self)
            let size = exitButtonSize
            let validReact = exitButtonReact.inset(by: UIEdgeInsets(top: -size.height, left: -size.width, bottom: -size.height, right: -size.width))
            if validReact.contains(point) {
                dismiss()
                didTapExitButton?()
            }
        }
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard addExitButton else { return }
        let aPath = UIBezierPath()

        aPath.move(to: CGPoint(x: exitButtonReact.minX, y: exitButtonReact.minY))
        aPath.addLine(to: CGPoint(x: exitButtonReact.maxX, y: exitButtonReact.maxY))
        aPath.close()

        aPath.move(to: CGPoint(x: exitButtonReact.maxX, y: exitButtonReact.minY))
        aPath.addLine(to: CGPoint(x: exitButtonReact.minX, y: exitButtonReact.maxY))
        aPath.close()

        UIColor.gray.set()
        aPath.lineJoinStyle = .round
        aPath.lineWidth = 2
        aPath.stroke()
    }
}

// MARK: - Appearance

public extension NotiflyCard {
    /// Title font
    dynamic var titleFont: UIFont {
        get { return titleLabel.font }
        set { titleLabel.font = newValue }
    }

    dynamic var title: String? { return titleLabel.text }

    /// Title text color
    dynamic var titleTextColor: UIColor {
        get { return titleLabel.textColor }
        set { titleLabel.textColor = newValue }
    }

    /// Subtitle font
    dynamic var subtitleFont: UIFont {
        get { return subtitleLabel.font }
        set { subtitleLabel.font = newValue }
    }

    dynamic var subtitle: String? { return subtitleLabel.text }

    /// Subtitle text color
    dynamic var subtitleTextColor: UIColor {
        get { return subtitleLabel.textColor }
        set { subtitleLabel.textColor = newValue }
    }

    /// height of the buttons
    dynamic var contentInsets: UIEdgeInsets {
        get { return _contentInsets }
        set { _contentInsets = newValue }
    }

    /// Dialog view corner radius
    dynamic var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }

    /// inset of the CustomView
    dynamic var customViewInsets: UIEdgeInsets {
        get { return _customViewInsets }
        set { _customViewInsets = newValue }
    }

    /// height of the buttons
    dynamic var buttonsHeight: CGFloat {
        get { return _buttonsHeight }
        set { _buttonsHeight = newValue }
    }

    /// Margin inset between buttons
    dynamic var buttonsSpace: CGFloat {
        get { return buttonsStackView.spacing }
        set { buttonsStackView.spacing = newValue }
    }

    /// Buttons distribution in stack view
    dynamic var buttonsDistribution: UIStackView.Distribution {
        get { return buttonsStackView.distribution }
        set { buttonsStackView.distribution = newValue }
    }

    /// Buttons aligns in stack view
    dynamic var buttonsAligment: UIStackView.Alignment {
        get { return buttonsStackView.alignment }
        set { buttonsStackView.alignment = newValue }
    }

    /// Buttons axis in stack view
    dynamic var buttonsAxis: NSLayoutConstraint.Axis {
        get { return buttonsStackView.axis }
        set {
            buttonsStackView.axis = newValue
            refreshView()
        }
    }
}

extension NotiflyCard {
    public enum Options {
        case backgroundColor(UIColor)
        case buttonsHeight(CGFloat)
        case cornerRounding(CGFloat)
        case titleFont(UIFont)
        case titleColor(UIColor)
        case subTitleFont(UIFont)
        case subTitleColor(UIColor)
        case subTitleSpacing(CGFloat)
        case customView(UIView)
        case customViewInsets(UIEdgeInsets)
        case contentInsets(UIEdgeInsets)
        case showExitButton(Bool)
        case buttonAxis(NSLayoutConstraint.Axis)
    }

    func setNotificationOptions(_ options: [Options]) {
        for option in options {
            switch option {
                case let .backgroundColor(color):
                    backgroundColor = color
                case let .showExitButton(value):
                    addExitButton = value
                case let .titleFont(font):
                    titleFont = font
                case let .titleColor(color):
                    titleTextColor = color
                case let .subTitleFont(font):
                    subtitleFont = font
                case let .subTitleColor(color):
                    subtitleTextColor = color
                case let .subTitleSpacing(spacing):
                    titleSubtitleSpacing = spacing
                case let .contentInsets(insets):
                    contentInsets = insets
                case let .cornerRounding(cornerRadius):
                    self.cornerRadius = cornerRadius
                case let .customView(view):
                    customView = view
                case let .customViewInsets(insets):
                    customViewInsets = insets
                case let .buttonsHeight(height):
                    _buttonsHeight = height
                case let .buttonAxis(value):
                    buttonsAxis = value
            }
        }
    }
}
