//
//  UndoNotifaction.swift
//  NotiflyExample
//
//  Created by Emre Armagan on 04.01.25.
//  Copyright © 2025 Emre Armagan. All rights reserved.
//

import Notifly
import UIKit

final class UndoNotifaction: NotiflyBase {
    private let titleLabel = UILabel()
    private let undoButton = UIButton()

    convenience init() {
        self.init(direction: .bottom)

        titleLabel.text = "3 Repositories deleted"
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)

        backgroundColor = .notiflyDefaultColor

        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.filled()
            config.title = "Undo"
            config.buttonSize = .small
            config.baseBackgroundColor = .white
            config.baseForegroundColor = .black
            config.cornerStyle = .dynamic
            undoButton.configuration = config

        } else {
            undoButton.setTitle("Undo", for: .normal)
        }

        let contentStackView = UIStackView()
        contentStackView.alignment = .center
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(undoButton)

        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentStackView)
        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            contentStackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)

        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
    }
}
