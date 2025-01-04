//
//  ReminderBanner.swift
//  SYBanner
//
//  Created by Emre Armagan on 04.01.25.
//  Copyright © 2025 Emre Armagan. All rights reserved.
//

import SYBanner
import UIKit

class ReminderBanner: SYBaseBanner {
    var isExpanded: Bool = false {
        didSet {
            toggleLayout()
        }
    }

    private let notificationIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "bell"))
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let notificationLabel: UILabel = {
        let label = UILabel()
        label.text = "Reminder (tap me)"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .lightGray
        return label
    }()

    private let circularIconView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.95, green: 0.5, blue: 0.3, alpha: 1)

        let iconImageView = UIImageView(image: UIImage(systemName: "stethoscope"))
        iconImageView.tintColor = .white
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(iconImageView)
        NSLayoutConstraint.activate([
            iconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            iconImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8)
        ])
        return view
    }()

    private let timeTextLabel: UILabel = {
        let label = UILabel()
        label.text = "12:00 - 12:30"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        return label
    }()

    private let detailsTextLabel: UILabel = {
        let label = UILabel()
        label.text = "Upcoming: Take Paracetamol 500mg"
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .secondaryLabel
        return label
    }()

    private let contentStackView = UIStackView()
    private let headerStackView = UIStackView()
    private let mainContentStackView = UIStackView()
    private let combinedContentStackView = UIStackView()

    convenience init(queue: SYBannerQueue) {
        self.init(direction: .top, queue: queue)
        setupUI()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = isExpanded ? 10 : frame.height / 2
        circularIconView.layer.cornerRadius = 15
    }

    private func setupUI() {
        backgroundColor = .black

        headerStackView.axis = .horizontal
        headerStackView.spacing = 8
        headerStackView.addArrangedSubview(notificationIcon)
        headerStackView.addArrangedSubview(notificationLabel)

        mainContentStackView.axis = .vertical
        mainContentStackView.spacing = 0
        mainContentStackView.addArrangedSubview(timeTextLabel)
        mainContentStackView.addArrangedSubview(detailsTextLabel)

        combinedContentStackView.axis = .vertical
        combinedContentStackView.spacing = 12
        combinedContentStackView.addArrangedSubview(headerStackView)
        combinedContentStackView.addArrangedSubview(mainContentStackView)

        contentStackView.axis = .horizontal
        contentStackView.spacing = 10
        contentStackView.alignment = .center
        contentStackView.distribution = .fillProportionally
        contentStackView.addArrangedSubview(combinedContentStackView)
        contentStackView.addArrangedSubview(circularIconView)

        addSubview(contentStackView)
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),

            notificationIcon.widthAnchor.constraint(equalToConstant: 18),
            notificationIcon.heightAnchor.constraint(equalToConstant: 18),

            circularIconView.widthAnchor.constraint(equalToConstant: 30),
            circularIconView.heightAnchor.constraint(equalToConstant: 30)
        ])

        mainContentStackView.isHidden = true
    }

    private func toggleLayout() {
        mainContentStackView.isHidden = !isExpanded
        setNeedsBannersDisplay()
    }
}
