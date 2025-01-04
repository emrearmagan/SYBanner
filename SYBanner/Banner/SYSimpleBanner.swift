//
//  SYSimpleBanner.swift
//  SYBanner
//
//  Created by Emre Armagan on 06.04.22.
//

import UIKit

/// A simple banner implementation that displays a customizable text message.
/// `SYSimpleBanner` is lightweight and versatile, allowing you to customize the text, font, color, and layout.
///
/// Example usage:
/// ```swift
/// let banner = SYSimpleBanner(
///     "Welcome to SYBanner!",
///     backgroundColor: .systemBlue,
///     direction: .top,
///     type: .float(.all(10)),
///     on: self
/// )
///
/// banner.present()
/// ```
open class SYSimpleBanner: SYBaseBanner {
    // MARK: Properties

    /// Constraints for the content within the banner.
    var contentConstraints: [NSLayoutConstraint] = []

    /// The label used to display the message text within the banner.
    open var titleLabel = UILabel()

    /// Insets applied around the content of the banner.
    open var contentInsets: UIEdgeInsets = .vertical(10) + .horizontal(30) {
        didSet { configureConstraints() }
    }

    /// The message text displayed in the banner.
    open var text: String? {
        get { titleLabel.text }
        set {
            titleLabel.text = newValue
            setNeedsBannersDisplay()
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
            setNeedsBannersDisplay()
        }
    }

    // MARK: Init

    /// Initializes a new `SYSimpleBanner` with customizable properties.
    ///
    /// - Parameters:
    ///   - message: The message to display in the banner.
    ///   - backgroundColor: The background color of the banner.
    ///   - direction: The direction from which the banner will appear. Defaults to `.bottom`.
    ///   - type: The banner's presentation type (e.g., `.stick` or `.float`). Defaults to `.float`.
    ///   - parent: The parent view controller where the banner will be displayed. Defaults to `nil`.
    ///   - queue: The queue managing the banner. Defaults to `.default`.
    public init(
        _ message: String,
        backgroundColor: UIColor = .syDefaultColor,
        direction: SYBannerDirection = .bottom,
        presenter: SYBannerPresenter = SYDefaultPresenter(),
        type: SYBannerType = .float(UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)),
        on parent: UIViewController? = nil,
        queue: SYBannerQueue = .default
    ) {
        super.init(direction: direction, presentation: presenter, queue: queue, on: parent)
        bannerType = type

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

    /// Sets up the banner's user interface.
    open func setupUI() {
        if !titleLabel.isDescendant(of: self) {
            addSubview(titleLabel)
        }

        titleLabel.numberOfLines = 0
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
        setNeedsBannersDisplay()
    }
}
