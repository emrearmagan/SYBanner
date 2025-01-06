//
//  ApprovalNotification.swift
//  NotiflyExample
//
//  Created by Emre Armagan on 04.01.25.
//  Copyright © 2025 Emre Armagan. All rights reserved.
//

import Notifly
import UIKit

final class ApprovalNotification: NotiflyBase {
    private let profileImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let denyButton = UIButton()
    private let approveButton = UIButton()

    convenience init() {
        self.init(direction: .top)

        setupUI()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 12
    }

    private func setupUI() {
        backgroundColor = .black

        profileImageView.image = UIImage(named: "user")
        profileImageView.backgroundColor = .white
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.layer.cornerRadius = 35 / 2
        profileImageView.clipsToBounds = true
        profileImageView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.text = "Request"
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        subtitleLabel.text = "Emre is asking you to contribute!"
        subtitleLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        subtitleLabel.textColor = .white.withAlphaComponent(0.8)
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false

        denyButton.setTitle("Deny", for: .normal)
        denyButton.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        denyButton.setTitleColor(.gray, for: .normal)
        denyButton.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        denyButton.layer.cornerRadius = 25 / 2
        denyButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        denyButton.clipsToBounds = true
        denyButton.translatesAutoresizingMaskIntoConstraints = false

        approveButton.setTitle("Approve", for: .normal)
        approveButton.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        approveButton.setTitleColor(.white, for: .normal)
        approveButton.backgroundColor = UIColor.systemPurple
        approveButton.layer.cornerRadius = 25 / 2
        approveButton.clipsToBounds = true
        approveButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        approveButton.translatesAutoresizingMaskIntoConstraints = false

        let labelsStackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        labelsStackView.axis = .vertical
        labelsStackView.spacing = 2
        labelsStackView.translatesAutoresizingMaskIntoConstraints = false

        let buttonsStackView = UIStackView(arrangedSubviews: [denyButton, approveButton])
        buttonsStackView.axis = .horizontal
        buttonsStackView.spacing = 8
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false

        let contentStackView = UIStackView(arrangedSubviews: [profileImageView, labelsStackView, buttonsStackView])
        contentStackView.axis = .horizontal
        contentStackView.spacing = 8
        contentStackView.alignment = .center
        contentStackView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(contentStackView)

        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            contentStackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),

            profileImageView.widthAnchor.constraint(equalToConstant: 35),
            profileImageView.heightAnchor.constraint(equalToConstant: 35),

            denyButton.heightAnchor.constraint(equalToConstant: 25),
            approveButton.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
}
