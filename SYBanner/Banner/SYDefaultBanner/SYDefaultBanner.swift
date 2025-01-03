//
//  SYDefaultBanner.swift
//  SYBanner
//
//  Created by Emre Armagan on 06.04.22.
//

import UIKit

/// A banner that displays an icon on the left and a title with a subtitle vertically on the right.
/// This banner is a subclass of `SYSimpleBanner` and extends its functionality to include an icon and additional labels.
public class SYDefaultBanner: SYSimpleBanner {
    // MARK: Properties

    private let stackView = UIStackView()
    private let iconImageView = UIImageView()
    private let textStackView = UIStackView()
    private let subtitleLabel = UILabel()

    private var _contentInsets: UIEdgeInsets = .all(10) {
        didSet { configureConstraints() }
    }

    override public var contentInsets: UIEdgeInsets {
        get { _contentInsets }
        set { _contentInsets = newValue }
    }

    /// The icon image to be displayed in the banner. If `nil`, the icon will be hidden.
    public var icon: UIImage? {
        get { iconImageView.image }
        set {
            iconImageView.image = newValue
            let visible = iconImageView.isHidden
            iconImageView.isHidden = newValue == nil
            if visible != iconImageView.isHidden {
                setNeedsBannerDisplay()
            }
        }
    }

    /// Size of the icon
    public var iconSize: CGSize = .init(width: 30, height: 30) {
        didSet { configureConstraints() }
    }

    /// The text for the subtitle label. If `nil`, the subtitle label will be hidden.
    public var subtitle: String? {
        get { subtitleLabel.text }
        set {
            subtitleLabel.text = newValue
            subtitleLabel.isHidden = newValue == nil
            setNeedsBannerDisplay()
        }
    }

    /// The font used for the subtitle label text.
    public var subtitleFont: UIFont {
        get { subtitleLabel.font }
        set {
            subtitleLabel.font = newValue
            setNeedsBannerDisplay()
        }
    }

    /// The color of the subtitle label text.
    public var subtitleColor: UIColor {
        get { subtitleLabel.textColor }
        set { subtitleLabel.textColor = newValue }
    }

    // MARK: Init

    public convenience init(
        _ title: String,
        _ message: String? = nil,
        style: SYBannerStyle,
        direction: SYBannerDirection = .bottom,
        presenter: SYBannerPresenter = SYDefaultPresenter(),
        type: SYBannerType = .float(UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)),
        on parent: UIViewController? = nil,
        queue: SYBannerQueue = .default) {
        self.init(title: title,
                  subtitle: message,
                  icon: style.image?.withRenderingMode(.alwaysTemplate),
                  backgroundColor: style.color,
                  direction: direction,
                  presenter: presenter,
                  type: type,
                  on: parent,
                  queue: queue
        )

        // Default values for Style
        titleSubtitleAlignment = .leading
        textColor = .white
        subtitleColor = .white
        iconImageView.tintColor = .white
    }

    public convenience init(
        _ title: String,
        _ message: String? = nil,
        icon: UIImage? = nil,
        backgroundColor: UIColor = .syDefaultColor,
        direction: SYBannerDirection = .bottom,
        presenter: SYBannerPresenter = SYDefaultPresenter(),
        type: SYBannerType = .float(UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)),
        on parent: UIViewController? = nil,
        queue: SYBannerQueue = .default
    ) {
        self.init(title: title,
                  subtitle: message,
                  icon: icon,
                  backgroundColor: backgroundColor,
                  direction: direction,
                  presenter: presenter,
                  type: type,
                  on: parent,
                  queue: queue
        )
    }

    public init(
        title: String,
        subtitle: String?,
        icon: UIImage?,
        backgroundColor: UIColor,
        direction: SYBannerDirection,
        presenter: SYBannerPresenter,
        type: SYBannerType,
        on parent: UIViewController?,
        queue: SYBannerQueue
    ) {
        super.init(title,
                   backgroundColor: backgroundColor,
                   direction: direction,
                   presenter: presenter,
                   type: type,
                   on: parent,
                   queue: queue
        )

        self.icon = icon
        self.subtitle = subtitle
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.size.height / 2
        layer.masksToBounds = true
    }

    // MARK: Methods

    override public func setupUI() {
        // Default values
        iconImageView.contentMode = .scaleAspectFit
        titleLabel.numberOfLines = 1
        textFont = .systemFont(ofSize: 17, weight: .semibold)
        subtitleFont = .systemFont(ofSize: 14, weight: .regular)
        subtitleLabel.numberOfLines = 0
        iconImageView.isHidden = icon == nil
        contentInsets = .all(10)

        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 10

        textStackView.axis = .vertical
        textStackView.alignment = .center
        textStackView.spacing = 0
        textStackView.addArrangedSubview(titleLabel)
        textStackView.addArrangedSubview(subtitleLabel)

        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(textStackView)
        addSubview(stackView)

        configureConstraints()
    }

    private func configureConstraints() {
        guard stackView.isDescendant(of: self) else { return }
        stackView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.deactivate(contentConstraints)

        contentConstraints = [
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: contentInsets.left),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -contentInsets.right),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: contentInsets.top),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -contentInsets.bottom),

            iconImageView.widthAnchor.constraint(equalToConstant: iconSize.width),
            iconImageView.heightAnchor.constraint(equalToConstant: iconSize.height)
        ]

        NSLayoutConstraint.activate(contentConstraints)
        setNeedsBannerDisplay()
    }
}

extension SYDefaultBanner {
    /// The spacing between the title and subtitle.
    public var titleSubtitleSpacing: CGFloat {
        get { textStackView.spacing }
        set { textStackView.spacing = newValue }
    }

    /// The alignment of the title and subtitle within the vertical stack.
    public var titleSubtitleAlignment: UIStackView.Alignment {
        get { textStackView.alignment }
        set { textStackView.alignment = newValue }
    }

    /// The spacing between the icon and the text stack.
    public var titleImageSpacing: CGFloat {
        get { stackView.spacing }
        set { stackView.spacing = newValue }
    }
}
