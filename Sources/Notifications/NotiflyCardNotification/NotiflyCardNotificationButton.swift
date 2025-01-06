//
//  NotiflyCardNotificationButton.swift
//  Notifly
//
//  Created by Emre Armagan on 07.04.22.
//

import UIKit

public class NotiflyCardNotificationButton: UIButton {
    public enum Style: Int {
        case `default` = 0
        case dismiss = 1
    }

    var title: String?
    var font: UIFont?
    var _tintColor: UIColor?
    var cornerRadius: CGFloat = 5

    override public var tintColor: UIColor! {
        didSet {
            updateButton()
        }
    }

    /// Closure that will be executed if the button is tapped
    var handler: (() -> Void)?
    private(set) var style: NotiflyCardNotificationButton.Style = .default

    /// Currently selected index
    public private(set) var selectedIndex: Int = 0

    public convenience init(title: String, font: UIFont = .systemFont(ofSize: 16), cornerRadius: CGFloat = 10, style: NotiflyCardNotificationButton.Style, tintColor: UIColor? = nil, handler: (() -> Void)? = nil) {
        self.init(frame: .zero)
        self.title = title
        self.style = style
        self.font = font
        self.handler = handler
        self.cornerRadius = cornerRadius
        _tintColor = tintColor

        setupButton()
    }

    // MARK: Lifecycle

    override public init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Functions

    private func setupButton() {
        setTitle(title, for: .normal)
        titleLabel?.font = font
        layer.cornerRadius = cornerRadius

        if let tintColor = _tintColor {
            self.tintColor = tintColor
        } else {
            if style == .dismiss {
                tintColor = .gray
            }
        }
        updateButton()
    }

    private func updateButton() {
        switch style {
            case .default:
                backgroundColor = tintColor
            case .dismiss:
                backgroundColor = .clear
                setTitleColor(tintColor, for: .normal)
        }
    }

    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        handler?()
    }
}
