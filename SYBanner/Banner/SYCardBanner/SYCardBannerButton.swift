//
//  SYCardBannerButton.swift
//  SYBanner
//
//  Created by Emre Armagan on 07.04.22.
//

import UIKit


@objc
public class SYCardBannerButton: UIButton {
    @objc(SYCardBannerButtonStyle)
    public enum Style : Int {
        case `default` = 0
        case dismiss = 1
    }

    var title: String?
    var font: UIFont?
    var _tintColor: UIColor?
    var cornerRadius: CGFloat = 5
    
    public override var tintColor: UIColor! {
        didSet {
            updateButton()
        }
    }
    /// Closure that will be executed if the button is tapped
    var handler: (() -> ())?
    @objc private(set) var style: SYCardBannerButton.Style = .default
    
    /// currently selected index
    @objc public private(set) var selectedIndex : Int = 0
    
    @objc
    public convenience init(title: String, font: UIFont = .systemFont(ofSize: 16), cornerRadius: CGFloat = 10, style: SYCardBannerButton.Style, tintColor: UIColor? = nil, handler: (() -> ())? = nil) {
        self.init(frame: .zero)
        self.title = title
        self.style = style
        self.font = font
        self.handler = handler
        self.cornerRadius = cornerRadius
        self._tintColor = tintColor
        
        setupButton()
    }
    
    // MARK: Lifecycle
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Functions
    private func setupButton() {
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = font
        self.layer.cornerRadius = cornerRadius
        
        if let tintColor = _tintColor {
            self.tintColor = tintColor
        } else {
            if style == .dismiss {
                self.tintColor = .gray
            }
        }
        updateButton()
    }
    
    private func updateButton() {
        switch style {
        case .default:
            self.backgroundColor = self.tintColor
        case .dismiss:
            self.backgroundColor = .clear
            self.setTitleColor(self.tintColor, for: .normal)
        }
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        handler?()
    }
}
