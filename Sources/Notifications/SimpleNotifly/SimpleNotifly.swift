//
//  SimpleNotifly.swift
//  Notifly
//
//  Created by Emre Armagan on 06.04.22.
//

import UIKit

/// A simple notification implementation that displays a customizable text message.
/// `SimpleNotifly` is lightweight and versatile, allowing you to customize the text, font, color, and layout.
///
/// Example usage:
/// ```swift
/// let notification = SimpleNotifly(
///     "Welcome to Notifly!",
///     backgroundColor: .systemBlue,
///     direction: .top,
///     type: .float(.all(10)),
///     on: self
/// )
///
/// notification.present()
/// ```
open class SimpleNotifly: NotiflyBase {
    // MARK: Properties

    /// Constraints for the content within the notification.
    var contentConstraints: [NSLayoutConstraint] = []

    /// The label used to display the message text within the notification.
    open var titleLabel = UILabel()

    /// Insets applied around the content of the notification.
    open var contentInsets: UIEdgeInsets = .vertical(10) + .horizontal(30) {
        didSet { configureConstraints() }
    }

    /// The message text displayed in the notification.
    open var text: String? {
        get { titleLabel.text }
        set {
            titleLabel.text = newValue
            setNeedsNotificationsDisplay()
        }
    }

    /// The color of the message text.
    open var textColor: UIColor {
        get { titleLabel.textColor }
        set { titleLabel.textColor = newValue }
    }

    /// The font used for the message text.
    open var textFont: UIFont {
        get { titleLabel.font }
        set {
            titleLabel.font = newValue
            setNeedsNotificationsDisplay()
        }
    }

    // MARK: Init

    /// Initializes a new `NotiflySimpleNotification` with customizable properties.
    ///
    /// - Parameters:
    ///   - message: The message to display in the notification.
    ///   - backgroundColor: The background color of the notification.
    ///   - direction: The direction from which the notification will appear. Defaults to `.bottom`.
    ///   - type: The notification's presentation type (e.g., `.stick` or `.float`). Defaults to `.float`.
    ///   - parent: The parent view controller where the notification will be displayed. Defaults to `nil`.
    ///   - queue: The queue managing the notification. Defaults to `.default`.
    public init(
        _ message: String,
        backgroundColor: UIColor = .notiflyDefaultColor,
        direction: NotiflyDirection = .bottom,
        presenter: NotiflyPresenter = NotiflyDefaultPresenter(),
        type: NotiflyType = .float(UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)),
        on parent: UIViewController? = nil,
        queue: NotiflyQueue = .default
    ) {
        super.init(direction: direction, presentation: presenter, queue: queue, on: parent)
        self.type = type

        self.backgroundColor = backgroundColor
        text = message
        setupUI()
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Lifecycle

    override open func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.size.height / 2
        layer.masksToBounds = true
    }

    // MARK: Methods

    override open func preferredContentSize() -> CGSize {
        return systemLayoutSizeFitting(preferredContainerSize)
    }

    // Auto-Layout does not calculate the size of a multiline label, so we define the maxWidth here
    override open func systemLayoutSizeFitting(_ targetSize: CGSize) -> CGSize {
        titleLabel.preferredMaxLayoutWidth = targetSize.width
        titleLabel.invalidateIntrinsicContentSize()
        return super.systemLayoutSizeFitting(targetSize)
    }

    /// Sets up the notification's user interface.
    open func setupUI() {
        if !titleLabel.isDescendant(of: self) {
            addSubview(titleLabel)
        }

        titleLabel.font = .systemFont(ofSize: 17, weight: .medium)
        titleLabel.numberOfLines = 0
        titleLabel.isUserInteractionEnabled = false

        configureConstraints()
    }

    private func configureConstraints() {
        guard titleLabel.isDescendant(of: self) else { return }

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.deactivate(contentConstraints)
        contentConstraints = [
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: contentInsets.left),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -contentInsets.right),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: contentInsets.top),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -contentInsets.bottom)
        ]

        NSLayoutConstraint.activate(contentConstraints)
        setNeedsNotificationsDisplay()
    }
}
