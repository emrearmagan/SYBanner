//
//  SYBanner.swift
//  SYBanner
//
//  Created by Emre Armagan on 06.04.22.
//

import UIKit

/// A banner that displays an icon on the left and a title with a subtitle vertically on the right.
/// This banner is a subclass of `SYSimpleBanner` and extends its functionality to include an icon and additional labels.
public class SYBanner: SYBaseBanner {
    // MARK: Properties

    private var contentConstraints: [NSLayoutConstraint] = []

    private let outerStackView = UIStackView()
    private let contentStackView = UIStackView()
    private let labelStackView = UIStackView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let imageView = UIImageView()

    public let backgroundView = SYBannerBackgroundView()

    override open var layoutMargins: UIEdgeInsets {
        get { backgroundView.layoutMargins }
        set { backgroundView.layoutMargins = newValue }
    }

    override open var backgroundColor: UIColor? {
        get { backgroundView.backgroundColor }
        set { backgroundView.backgroundColor = newValue }
    }

    override public var insetsLayoutMarginsFromSafeArea: Bool {
        get { backgroundView.insetsLayoutMarginsFromSafeArea }
        set { backgroundView.insetsLayoutMarginsFromSafeArea = newValue }
    }

    public var configuration: SYBanner.Configuration = .default {
        didSet {
            updateViews()
        }
    }

    /// The message text displayed in the banner.
    open var title: String? {
        get { titleLabel.text }
        set {
            titleLabel.text = newValue
            setNeedsBannersDisplay()
        }
    }

    /// The text for the subtitle label. If `nil`, the subtitle label will be hidden.
    public var subtitle: String? {
        get { subtitleLabel.text }
        set {
            subtitleLabel.text = newValue
            subtitleLabel.isHidden = newValue == nil
            setNeedsBannersDisplay()
        }
    }

//    override public func preferredContentSize() -> CGSize {
//        // Use system fitting size with intrinsic content
//        return systemLayoutSizeFitting(
//            prefferedContainerSize,
//            withHorizontalFittingPriority: .fittingSizeLevel,
//            verticalFittingPriority: .fittingSizeLevel
//        )
//    }

    // MARK: Init

    public init(
        _ title: String,
        subtitle: String? = nil,
        configuration: SYBanner.Configuration = .default,
        direction: SYBannerDirection = .bottom,
        presenter: SYBannerPresenter = SYDefaultPresenter(),
        type: SYBannerType = .float(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)),
        on parent: UIViewController? = nil,
        queue: SYBannerQueue = .default
    ) {
        self.configuration = configuration

        super.init(direction: direction, presentation: presenter, queue: queue, on: parent)
        self.title = title
        self.subtitle = subtitle
        setupUI()
    }

    // MARK: Methods

    open func setupUI() {
        // Default values
        layoutMargins = .all(10)
        subtitleLabel.numberOfLines = 0
        titleLabel.numberOfLines = 1
        outerStackView.axis = .vertical
        contentStackView.distribution = .fill
        labelStackView.axis = .vertical
        labelStackView.distribution = .fill
        imageView.contentMode = .scaleAspectFit

        addSubview(backgroundView)
        backgroundView.addSubview(outerStackView)

        outerStackView.addArrangedSubview(contentStackView)
        contentStackView.addArrangedSubview(imageView)
        contentStackView.addArrangedSubview(labelStackView)

        labelStackView.addArrangedSubview(titleLabel)
        labelStackView.addArrangedSubview(subtitleLabel)

        imageView.setContentHuggingPriority(.required, for: .horizontal)
        imageView.setContentHuggingPriority(.required, for: .vertical)
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        subtitleLabel.setContentHuggingPriority(.required, for: .vertical)

        updateViews()

        backgroundView.isUserInteractionEnabled = false
        backgroundView.isUserInteractionEnabled = false
        outerStackView.isUserInteractionEnabled = false
        contentStackView.isUserInteractionEnabled = false
    }

    private func updateViews() {
        updateImagePlacement()
        imageView.isHidden = configuration.icon?.image == nil
        imageView.image = configuration.icon?.image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = configuration.icon?.tintColor

        titleLabel.isHidden = title == nil
        titleLabel.font = configuration.titleFont
        titleLabel.textColor = configuration.titleColor

        subtitleLabel.isHidden = subtitleLabel.text == nil
        subtitleLabel.font = configuration.subtitleFont
        subtitleLabel.textColor = configuration.subtitleColor

        labelStackView.isHidden = titleLabel.isHidden && subtitleLabel.isHidden
        labelStackView.spacing = configuration.titleSubtitleSpacing
        labelStackView.alignment = configuration.textAlignment

        contentStackView.spacing = configuration.imagePadding
        contentStackView.alignment = configuration.contentAlignment

        outerStackView.alignment = configuration.textAlignment

        backgroundView.bgColor = configuration.backgroundColor
        backgroundView.cornerRadius = configuration.cornerRadius

        configureConstraints()
        setNeedsBannersDisplay()
    }

    private func updateImagePlacement() {
        guard let icon = configuration.icon else { return }

        imageView.removeFromSuperview()

        switch icon.placement {
            case .leading, .trailing:
                contentStackView.axis = .horizontal
                contentStackView.insertArrangedSubview(imageView, at: icon.placement == .leading ? 0 : 1)

            case .bottom, .top:
                contentStackView.axis = .vertical
                contentStackView.insertArrangedSubview(imageView, at: icon.placement == .top ? 0 : 1)
        }
    }
}

// MARK: UI

extension SYBanner {
    private func configureConstraints() {
        NSLayoutConstraint.deactivate(contentConstraints)
        guard backgroundView.isDescendant(of: self), outerStackView.isDescendant(of: backgroundView) else { return }

        outerStackView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.translatesAutoresizingMaskIntoConstraints = false

        contentConstraints = [
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),

            outerStackView.leadingAnchor.constraint(equalTo: backgroundView.layoutMarginsGuide.leadingAnchor),
            outerStackView.trailingAnchor.constraint(equalTo: backgroundView.layoutMarginsGuide.trailingAnchor),
            outerStackView.topAnchor.constraint(equalTo: backgroundView.layoutMarginsGuide.topAnchor),
            outerStackView.bottomAnchor.constraint(equalTo: backgroundView.layoutMarginsGuide.bottomAnchor)
        ]

        if let iconSize = configuration.icon?.size {
            let imageWidthConstraint = imageView.widthAnchor.constraint(equalToConstant: iconSize.width)
            let imageHeightConstraint = imageView.heightAnchor.constraint(equalToConstant: iconSize.height)
            imageWidthConstraint.priority = .defaultHigh
            imageHeightConstraint.priority = .defaultHigh
            contentConstraints.append(contentsOf: [imageWidthConstraint, imageHeightConstraint])
        }

        NSLayoutConstraint.activate(contentConstraints)
    }
}
